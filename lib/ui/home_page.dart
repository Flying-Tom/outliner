import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'package:outliner/utils/toc_converter.dart';
import 'package:outliner/services/pdf_service.dart';
import 'package:outliner/models/toc_entry.dart';
import 'package:outliner/generated/l10n/app_localizations.dart';
import 'widgets/pdf_input_section.dart';
import 'widgets/preview_status_panel.dart';

class AppHome extends StatefulWidget {
  final List<TextEditingController> levelControllers;
  final bool trimLines;
  final ValueChanged<bool> onTrimLinesChanged;

  const AppHome({
    super.key,
    required this.levelControllers,
    required this.trimLines,
    required this.onTrimLinesChanged,
  });

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final _pdfPathController = TextEditingController();
  final _tocController = TextEditingController();
  final _offsetController = TextEditingController();
  late final List<TextEditingController> _levelControllers;
  late bool _trimLines;

  List<TocEntry> _previewEntries = [];
  bool _isRunning = false;
  Timer? _previewTimer;

  @override
  void initState() {
    super.initState();
    _levelControllers = widget.levelControllers;
    _trimLines = widget.trimLines;
    _tocController.addListener(_schedulePreviewRefresh);
    for (final controller in _levelControllers) {
      controller.addListener(_schedulePreviewRefresh);
    }
    _offsetController.addListener(_schedulePreviewRefresh);
    _schedulePreviewRefresh();
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    _pdfPathController.dispose();
    _tocController.dispose();
    _offsetController.dispose();
    // Note: `_levelControllers` are managed by parent and should not be disposed here.
    super.dispose();
  }

  void _schedulePreviewRefresh() {
    _previewTimer?.cancel();
    _previewTimer = Timer(const Duration(milliseconds: 350), _refreshPreview);
  }

  void _refreshPreview() {
    final offset = int.tryParse(_offsetController.text.trim()) ?? 0;
    final patterns = <RegExp?>[];
    try {
      for (final controller in _levelControllers) {
        final raw = controller.text.trim();
        patterns.add(raw.isEmpty ? null : RegExp(raw));
      }
    } catch (error) {
      return;
    }
    final entries = TocConverter.convert(
      _tocController.text,
      offset: offset,
      levelPatterns: patterns,
      trimLines: _trimLines,
    );
    if (mounted) {
      setState(() {
        _previewEntries = entries;
      });
    }
  }

  Future<void> _pickPdf() async {
    const typeGroup = XTypeGroup(label: 'PDF', extensions: ['pdf']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) {
      return;
    }
    setState(() {
      _pdfPathController.text = file.path;
    });
  }

  Future<void> _extractOutlineManually() async {
    final pdfPath = _pdfPathController.text.trim();
    if (pdfPath.isEmpty) {
      _showMessage(AppLocalizations.of(context)!.choosePdfFirst);
      return;
    }

    try {
      final outline = await PdfService.extractOutline(pdfPath);
      if (!mounted) return;
      if (outline.isEmpty) {
        _showMessage(AppLocalizations.of(context)!.noPdfOutline);
      } else {
        setState(() {
          _tocController.text = outline;
        });
        _schedulePreviewRefresh();
        _showMessage(AppLocalizations.of(context)!.outlineExtracted);
      }
    } catch (error) {
      if (mounted) {
        _showMessage('${AppLocalizations.of(context)!.error}$error');
      }
    }
  }

  Future<void> _runConversion() async {
    final pdfPath = _pdfPathController.text.trim();
    final tocText = _tocController.text;

    if (pdfPath.isEmpty) {
      _showMessage(AppLocalizations.of(context)!.choosePdfFirst);
      return;
    }
    if (tocText.isEmpty) {
      _showMessage(AppLocalizations.of(context)!.pasteDirectoryText);
      return;
    }

    final offsetText = _offsetController.text.trim();
    final parsedOffset = offsetText.isEmpty ? 0 : int.tryParse(offsetText);
    if (parsedOffset == null) {
      _showMessage(AppLocalizations.of(context)!.pageOffsetMustBeInt);
      return;
    }

    final patterns = <RegExp?>[];
    try {
      for (final controller in _levelControllers) {
        final raw = controller.text.trim();
        patterns.add(raw.isEmpty ? null : RegExp(raw));
      }
    } catch (error) {
      _showMessage('${AppLocalizations.of(context)!.invalidRegex}$error');
      return;
    }

    final entries = TocConverter.convert(
      tocText,
      offset: parsedOffset,
      levelPatterns: patterns,
      trimLines: _trimLines,
    );

    setState(() {
      _isRunning = true;
    });

    try {
      final newPath = await PdfService.addBookmarks(pdfPath, entries);
      if (!mounted) return;
      _showMessage(
        '${AppLocalizations.of(context)!.finishedWriting} ${path.basename(newPath)}',
      );
    } catch (error) {
      if (mounted) {
        _showMessage('${AppLocalizations.of(context)!.error}$error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: PdfInputSection(
                pdfPathController: _pdfPathController,
                tocController: _tocController,
                onPickPdf: _pickPdf,
                onExtractOutline: _extractOutlineManually,
                offsetController: _offsetController,
              ),
            ),
            const SizedBox(width: 12),
            // Right column: preview (with offset inside), insert button
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: PreviewStatusPanel(
                        entries: _previewEntries,
                        offsetController: _offsetController,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isRunning ? null : _runConversion,
                      icon: _isRunning
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.play_arrow),
                      label:
                          Text(AppLocalizations.of(context)!.insertBookmarks),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
