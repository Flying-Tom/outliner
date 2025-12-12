import 'package:flutter/material.dart';
import 'package:outliner/models/toc_entry.dart';
import 'package:outliner/generated/l10n/app_localizations.dart';

class TocPreviewItem extends StatelessWidget {
  final TocEntry entry;
  final int index;

  const TocPreviewItem({
    super.key,
    required this.entry,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isUnrecognized = entry.page == 1 &&
        (entry.title.isEmpty || entry.title.startsWith(RegExp(r'^\s*\$')));

    final displayTitle = entry.title.isEmpty ? '<Untitled>' : entry.title;
    final titleWithMarker = isUnrecognized
        ? '${AppLocalizations.of(context)!.unrecognized} $displayTitle'
        : displayTitle;

    final levelColors = [
      Theme.of(context).colorScheme.onSurface.withAlpha((0.6 * 255).round()),
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.teal.shade300,
    ];
    final markerColor =
        levelColors[entry.level.clamp(0, levelColors.length - 1).toInt()];
    final effectiveMarkerColor =
        isUnrecognized ? Theme.of(context).colorScheme.error : markerColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isUnrecognized
              ? Theme.of(context).colorScheme.errorContainer
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  SizedBox(width: entry.level * 12.0),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: effectiveMarkerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      titleWithMarker,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnrecognized
                            ? Theme.of(context).colorScheme.error
                            : DefaultTextStyle.of(context).style.color,
                        fontFamily: isUnrecognized ? 'monospace' : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                '${entry.page}',
                style: TextStyle(
                  fontSize: 12,
                  color: isUnrecognized
                      ? Theme.of(context).colorScheme.error
                      : DefaultTextStyle.of(context).style.color,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: Text(
                '${entry.realPage}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isUnrecognized
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
