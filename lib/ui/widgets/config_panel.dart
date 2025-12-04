import 'package:flutter/material.dart';
import 'package:pdf_toc/generated/l10n/app_localizations.dart';
import 'level_fields_widget.dart';

class ConfigPanel extends StatelessWidget {
  final TextEditingController offsetController;
  final bool trimLines;
  final List<TextEditingController> levelControllers;
  final ValueChanged<bool> onTrimLinesChanged;
  final VoidCallback onRunConversion;
  final bool isRunning;

  const ConfigPanel({
    super.key,
    required this.offsetController,
    required this.trimLines,
    required this.levelControllers,
    required this.onTrimLinesChanged,
    required this.onRunConversion,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.configuration,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: offsetController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.pageOffset,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(6),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.tocHierarchy,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppLocalizations.of(context)!.trimLineWhitespace,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Transform.scale(
                      scale: 0.9,
                      child: Switch.adaptive(
                        value: trimLines,
                        onChanged: onTrimLinesChanged,
                      ),
                    ),
                    onTap: () {
                      onTrimLinesChanged(!trimLines);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.levelPatterns,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: LevelFieldsWidget(
                        controllers: levelControllers,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isRunning ? null : onRunConversion,
              icon: isRunning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(AppLocalizations.of(context)!.insertBookmarks),
            ),
          ),
          if (isRunning)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
