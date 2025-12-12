import 'package:flutter/material.dart';
import 'package:outliner/generated/l10n/app_localizations.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:async';

class PdfInputSection extends StatefulWidget {
  final TextEditingController pdfPathController;
  final TextEditingController tocController;
  final VoidCallback onPickPdf;
  final VoidCallback? onExtractOutline;
  final TextEditingController? offsetController;

  const PdfInputSection({
    super.key,
    required this.pdfPathController,
    required this.tocController,
    required this.onPickPdf,
    this.onExtractOutline,
    this.offsetController,
  });

  @override
  State<PdfInputSection> createState() => _PdfInputSectionState();
}

class _PdfInputSectionState extends State<PdfInputSection> {
  bool _dragging = false;
  String? _dropError;
  Timer? _errorTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.pdfInput,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropTarget(
            onDragEntered: (detail) => setState(() => _dragging = true),
            onDragExited: (detail) => setState(() => _dragging = false),
            onDragDone: (detail) {
              setState(() => _dragging = false);
              if (detail.files.isNotEmpty) {
                final file = detail.files.first;
                final path = file.path;
                if (path.isNotEmpty && path.toLowerCase().endsWith('.pdf')) {
                  widget.pdfPathController.text = path;
                  setState(() => _dropError = null);
                } else {
                  final msg =
                      '${AppLocalizations.of(context)!.error} Not a PDF file';
                  setState(() => _dropError = msg);
                  _errorTimer?.cancel();
                  _errorTimer = Timer(const Duration(seconds: 4), () {
                    if (mounted) setState(() => _dropError = null);
                  });
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  } catch (_) {}
                }
              }
            },
            child: TextField(
              controller: widget.pdfPathController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.pdfFile,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _dragging
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _dragging
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: widget.onPickPdf,
                  tooltip: AppLocalizations.of(context)!.browsePdf,
                ),
              ),
              readOnly: true,
            ),
          ),
          if (_dropError != null) ...[
            const SizedBox(height: 6),
            Text(
              _dropError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              controller: widget.tocController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.tocText,
                hintText: (widget.offsetController == null ||
                        widget.offsetController!.text.trim().isEmpty)
                    ? AppLocalizations.of(context)!.tocHint
                    : '${AppLocalizations.of(context)!.tocHint} (${AppLocalizations.of(context)!.pageOffset}: ${widget.offsetController!.text})',
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onExtractOutline,
              icon: const Icon(Icons.auto_awesome),
              label: Text(AppLocalizations.of(context)!.extractOutline),
            ),
          ),
        ],
      ),
    );
  }
}
