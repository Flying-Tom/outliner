import 'package:flutter/material.dart';
import 'package:outliner/generated/l10n/app_localizations.dart';
import 'package:outliner/utils/toc_converter.dart';
import 'widgets/level_fields_widget.dart';

class SettingsPage extends StatefulWidget {
  final List<TextEditingController> levelControllers;
  final bool trimLines;
  final ValueChanged<bool> onTrimLinesChanged;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final String? currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const SettingsPage({
    super.key,
    required this.levelControllers,
    required this.trimLines,
    required this.onTrimLinesChanged,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class TocEditorPage extends StatefulWidget {
  final List<String> initialTexts;
  final bool initialTrim;

  const TocEditorPage({
    super.key,
    required this.initialTexts,
    required this.initialTrim,
  });

  @override
  State<TocEditorPage> createState() => _TocEditorPageState();
}

class _TocEditorPageState extends State<TocEditorPage> {
  late List<TextEditingController> _controllers;
  late bool _trim;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _controllers =
        widget.initialTexts.map((t) => TextEditingController(text: t)).toList();
    _trim = widget.initialTrim;
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  void _reset() {
    for (var i = 0; i < _controllers.length; i++) {
      final def = (i < TocConverter.defaultLevelExpressions.length)
          ? TocConverter.defaultLevelExpressions[i]
          : '';
      _controllers[i].text = def;
    }
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.resetDefaultsDone)),
    );
    setState(() {});
  }

  void _save() {
    final texts = _controllers.map((c) => c.text).toList();
    Navigator.pop(context, {'texts': texts, 'trim': _trim});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.tocHierarchy),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(AppLocalizations.of(context)!.trimLineWhitespace),
                trailing: Switch.adaptive(
                  value: _trim,
                  onChanged: (v) => setState(() => _trim = v),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: LevelFieldsWidget(controllers: _controllers),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.restore),
                  label: Text(AppLocalizations.of(context)!.resetToDefaults),
                ),
                const SizedBox(width: 8),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(AppLocalizations.of(context)!.saveSettings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsPageState extends State<SettingsPage> {
  late List<TextEditingController> _localControllers;
  late bool _localTrim;

  @override
  void initState() {
    super.initState();
    _localControllers = widget.levelControllers
        .map((c) => TextEditingController(text: c.text))
        .toList();
    _localTrim = widget.trimLines;
  }

  @override
  void dispose() {
    for (final c in _localControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.configuration),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language selection
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              subtitle: Text(widget.currentLanguage == null
                  ? AppLocalizations.of(context)!.systemTheme
                  : (widget.currentLanguage == 'zh' ? '中文' : 'English')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final choice = await showDialog<String?>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: Text(AppLocalizations.of(context)!.language),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, 'system'),
                        child: Text(AppLocalizations.of(context)!.systemTheme),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, 'zh'),
                        child: const Text('中文'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, 'en'),
                        child: const Text('English'),
                      ),
                    ],
                  ),
                );
                if (choice != null) {
                  widget.onLanguageChanged(choice);
                }
              },
            ),

            // Theme selection
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.brightness_6),
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text(() {
                switch (widget.currentThemeMode) {
                  case ThemeMode.light:
                    return AppLocalizations.of(context)!.lightTheme;
                  case ThemeMode.dark:
                    return AppLocalizations.of(context)!.darkTheme;
                  default:
                    return AppLocalizations.of(context)!.systemTheme;
                }
              }()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final choice = await showDialog<ThemeMode?>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: Text(AppLocalizations.of(context)!.theme),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, ThemeMode.system),
                        child: Text(AppLocalizations.of(context)!.systemTheme),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, ThemeMode.light),
                        child: Text(AppLocalizations.of(context)!.lightTheme),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, ThemeMode.dark),
                        child: Text(AppLocalizations.of(context)!.darkTheme),
                      ),
                    ],
                  ),
                );
                if (choice != null) widget.onThemeModeChanged(choice);
              },
            ),

            const Divider(),

            // TOC Hierarchy opens a full-width modal bottom sheet editor
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.view_list),
              title: Text(AppLocalizations.of(context)!.tocHierarchy),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final initialTexts =
                    widget.levelControllers.map((c) => c.text).toList();
                final result =
                    await showModalBottomSheet<Map<String, dynamic>?>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  builder: (ctx) => FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 0.85,
                    alignment: Alignment.topCenter,
                    child: TocEditorPage(
                      initialTexts: initialTexts,
                      initialTrim: _localTrim,
                    ),
                  ),
                );

                if (result != null) {
                  final texts =
                      (result['texts'] as List<dynamic>).cast<String>();
                  for (var i = 0;
                      i < texts.length && i < widget.levelControllers.length;
                      i++) {
                    widget.levelControllers[i].text = texts[i];
                  }
                  final trim = result['trim'] as bool? ?? _localTrim;
                  widget.onTrimLinesChanged(trim);
                  setState(() {
                    _localTrim = trim;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
