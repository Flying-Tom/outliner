// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PDF Bookmark Editor';

  @override
  String get pdfInput => 'Document & Input';

  @override
  String get configuration => 'Configuration';

  @override
  String get selectPdf => 'Select PDF';

  @override
  String get browsePdf => 'Browse PDF';

  @override
  String get pdfFile => 'PDF file';

  @override
  String get tocText => 'Table of contents';

  @override
  String get tocHint => 'Paste the directory text here';

  @override
  String get pageOffset => 'Page offset';

  @override
  String get levelPatterns => 'Level Patterns';

  @override
  String get insertBookmarks => 'Insert Bookmarks';

  @override
  String get previewStatus => 'Preview & Status';

  @override
  String get status => 'Status';

  @override
  String get logs => 'Logs';

  @override
  String get previewHint =>
      'Preview will appear when you paste directory text.';

  @override
  String get noEntriesParsed => 'No entries parsed — check format or patterns';

  @override
  String get logsHint => 'Logs will appear here';

  @override
  String get choosePdfFirst => 'Choose a PDF file first';

  @override
  String get pasteDirectoryText => 'Paste the directory text before running';

  @override
  String get pageOffsetMustBeInt => 'Page offset must be an integer';

  @override
  String get invalidRegex => 'Invalid regex: ';

  @override
  String get addingBookmarks => 'Adding bookmarks...';

  @override
  String get finishedWriting => 'Finished writing';

  @override
  String get error => 'Error: ';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get trimLineWhitespace => 'Trim whitespace';

  @override
  String get tocHierarchy => 'TOC Hierarchy';

  @override
  String get unrecognized => '[UNRECOGNIZED]';

  @override
  String get title => 'Title';

  @override
  String get markedPage => 'Marked Page';

  @override
  String get actualPage => 'Actual Page';

  @override
  String get extractOutline => 'Extract Outline';

  @override
  String get outlineExtracted => 'Outline extracted successfully';

  @override
  String get resetToDefaults => 'Reset to defaults';

  @override
  String get resetDefaultsDone => 'Defaults restored';

  @override
  String get saveSettings => 'Save';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get noPdfOutline => 'No outline found in this PDF';
}
