import 'package:flutter/material.dart';
import 'package:outliner/generated/l10n/app_localizations.dart';

/// Language selector icon widget for the app bar
/// Shows a globe icon with language indicator badge
class _LanguageSelectorIcon extends StatelessWidget {
  final String? currentLanguage;

  const _LanguageSelectorIcon({
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isZh = currentLanguage == 'zh';

    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.language_rounded,
          size: 24,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isZh ? '中' : 'En',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Language selector menu widget
/// Encapsulates the language selection logic and UI
class LanguageSelectorMenu extends StatelessWidget {
  final String? currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelectorMenu({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: PopupMenuButton<String>(
        tooltip: AppLocalizations.of(context)!.language,
        icon: _LanguageSelectorIcon(
          currentLanguage: currentLanguage,
        ),
        onSelected: onLanguageChanged,
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'zh', child: Text('中文')),
          PopupMenuItem(value: 'en', child: Text('English')),
        ],
      ),
    );
  }
}
