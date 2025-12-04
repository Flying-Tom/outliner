import 'package:flutter/material.dart';
import 'package:pdf_toc/generated/l10n/app_localizations.dart';

/// Theme selector menu widget
/// Encapsulates the theme selection logic and UI
class ThemeSelectorMenu extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const ThemeSelectorMenu({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return Icons.brightness_4;
      case ThemeMode.light:
        return Icons.brightness_7;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: PopupMenuButton<ThemeMode>(
        tooltip: AppLocalizations.of(context)!.theme,
        icon: Icon(_getThemeIcon(currentThemeMode)),
        onSelected: onThemeModeChanged,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: ThemeMode.system,
            child: Text(AppLocalizations.of(context)!.systemTheme),
          ),
          PopupMenuItem(
            value: ThemeMode.light,
            child: Text(AppLocalizations.of(context)!.lightTheme),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Text(AppLocalizations.of(context)!.darkTheme),
          ),
        ],
      ),
    );
  }
}
