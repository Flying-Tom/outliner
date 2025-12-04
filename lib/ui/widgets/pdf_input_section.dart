import 'package:flutter/material.dart';
import 'package:pdf_toc/generated/l10n/app_localizations.dart';

class PdfInputSection extends StatelessWidget {
  final TextEditingController pdfPathController;
  final TextEditingController tocController;
  final VoidCallback onPickPdf;
  final VoidCallback? onExtractOutline;

  const PdfInputSection({
    super.key,
    required this.pdfPathController,
    required this.tocController,
    required this.onPickPdf,
    this.onExtractOutline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.pdfInput,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: pdfPathController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.pdfFile,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.folder_open),
                onPressed: onPickPdf,
                tooltip: AppLocalizations.of(context)!.browsePdf,
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onExtractOutline,
            icon: const Icon(Icons.auto_awesome),
            label: Text(AppLocalizations.of(context)!.extractOutline),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              controller: tocController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.tocText,
                hintText: AppLocalizations.of(context)!.tocHint,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
