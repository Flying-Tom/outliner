import 'package:flutter/material.dart';
import 'package:outliner/models/toc_entry.dart';
import 'package:outliner/generated/l10n/app_localizations.dart';
import 'toc_preview_item.dart';

class PreviewPanel extends StatelessWidget {
  final List<TocEntry> entries;

  const PreviewPanel({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final headerRow = Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                AppLocalizations.of(context)!.title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                AppLocalizations.of(context)!.markedPage,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: Text(
                AppLocalizations.of(context)!.actualPage,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );

    final entriesList = ListView.builder(
      itemCount: entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return TocPreviewItem(
          entry: entries[index],
          index: index,
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [headerRow, entriesList],
    );
  }
}
