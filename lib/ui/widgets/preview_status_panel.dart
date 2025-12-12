import 'package:flutter/material.dart';
import 'package:outliner/models/toc_entry.dart';
import 'package:outliner/generated/l10n/app_localizations.dart';
import 'preview_panel.dart';

class PreviewStatusPanel extends StatelessWidget {
  final List<TocEntry> entries;

  const PreviewStatusPanel({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.previewStatus,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: PreviewPanel(
                entries: entries,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
