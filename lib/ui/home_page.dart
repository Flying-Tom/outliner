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
import 'widgets/config_panel.dart';
import 'widgets/app_bar_title.dart';
import 'widgets/language_selector.dart';
import 'widgets/theme_selector_menu.dart';

class AppHome extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final Locale? initialLocale;
  final ValueChanged<Locale?> onLocaleChanged;

  const AppHome({
    super.key,
    this.initialThemeMode = ThemeMode.system,
    required this.onThemeChanged,
    this.initialLocale,
    required this.onLocaleChanged,
  });

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final _pdfPathController = TextEditingController();
  final _tocController = TextEditingController();
  final _offsetController = TextEditingController(text: '0');
  late final List<TextEditingController> _levelControllers;
  bool _trimLines = true;

  String? _language;
  late ThemeMode _currentThemeMode;
  List<TocEntry> _previewEntries = [];
  bool _isRunning = false;
  Timer? _previewTimer;

  @override
  void initState() {
    super.initState();
    _currentThemeMode = widget.initialThemeMode;
    _levelControllers = List.generate(
      TocConverter.defaultLevelExpressions.length,
      (index) => TextEditingController(
        text: TocConverter.defaultLevelExpressions[index],
      ),
    );
    _tocController.addListener(_schedulePreviewRefresh);
    for (final controller in _levelControllers) {
      controller.addListener(_schedulePreviewRefresh);
    }
    _offsetController.addListener(_schedulePreviewRefresh);
    _schedulePreviewRefresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize language from widget or system locale
    _language = widget.initialLocale?.languageCode ??
        Localizations.localeOf(context).languageCode;
  }

  @override
  void dispose() {
    _previewTimer?.cancel();
    _pdfPathController.dispose();
    _tocController.dispose();
    _offsetController.dispose();
    for (final controller in _levelControllers) {
      controller.dispose();
    }
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

    final parsedOffset = int.tryParse(_offsetController.text.trim());
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
      appBar: AppBar(
        title: const AppBarTitle(),
        actions: [
          LanguageSelectorMenu(
            currentLanguage: _language,
            onLanguageChanged: (value) {
              setState(() {
                _language = value;
              });
              widget.onLocaleChanged(Locale(value));
            },
          ),
          ThemeSelectorMenu(
            currentThemeMode: _currentThemeMode,
            onThemeModeChanged: (mode) {
              setState(() {
                _currentThemeMode = mode;
              });
              widget.onThemeChanged(mode);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: PdfInputSection(
                pdfPathController: _pdfPathController,
                tocController: _tocController,
                onPickPdf: _pickPdf,
                onExtractOutline: _extractOutlineManually,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: PreviewStatusPanel(
                  entries: _previewEntries,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ConfigPanel(
                offsetController: _offsetController,
                trimLines: _trimLines,
                levelControllers: _levelControllers,
                onTrimLinesChanged: (value) {
                  setState(() {
                    _trimLines = value;
                    _schedulePreviewRefresh();
                  });
                },
                onRunConversion: _runConversion,
                isRunning: _isRunning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
