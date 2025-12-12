import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF Bookmark Editor'**
  String get appTitle;

  /// No description provided for @pdfInput.
  ///
  /// In en, this message translates to:
  /// **'Document & Input'**
  String get pdfInput;

  /// No description provided for @configuration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @selectPdf.
  ///
  /// In en, this message translates to:
  /// **'Select PDF'**
  String get selectPdf;

  /// No description provided for @browsePdf.
  ///
  /// In en, this message translates to:
  /// **'Browse PDF'**
  String get browsePdf;

  /// No description provided for @pdfFile.
  ///
  /// In en, this message translates to:
  /// **'PDF file'**
  String get pdfFile;

  /// No description provided for @tocText.
  ///
  /// In en, this message translates to:
  /// **'Table of contents'**
  String get tocText;

  /// No description provided for @tocHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the directory text here'**
  String get tocHint;

  /// No description provided for @pageOffset.
  ///
  /// In en, this message translates to:
  /// **'Page offset'**
  String get pageOffset;

  /// No description provided for @levelPatterns.
  ///
  /// In en, this message translates to:
  /// **'Level Patterns'**
  String get levelPatterns;

  /// No description provided for @insertBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Insert Bookmarks'**
  String get insertBookmarks;

  /// No description provided for @previewStatus.
  ///
  /// In en, this message translates to:
  /// **'Preview & Status'**
  String get previewStatus;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @previewHint.
  ///
  /// In en, this message translates to:
  /// **'Preview will appear when you paste directory text.'**
  String get previewHint;

  /// No description provided for @noEntriesParsed.
  ///
  /// In en, this message translates to:
  /// **'No entries parsed — check format or patterns'**
  String get noEntriesParsed;

  /// No description provided for @logsHint.
  ///
  /// In en, this message translates to:
  /// **'Logs will appear here'**
  String get logsHint;

  /// No description provided for @choosePdfFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a PDF file first'**
  String get choosePdfFirst;

  /// No description provided for @pasteDirectoryText.
  ///
  /// In en, this message translates to:
  /// **'Paste the directory text before running'**
  String get pasteDirectoryText;

  /// No description provided for @pageOffsetMustBeInt.
  ///
  /// In en, this message translates to:
  /// **'Page offset must be an integer'**
  String get pageOffsetMustBeInt;

  /// No description provided for @invalidRegex.
  ///
  /// In en, this message translates to:
  /// **'Invalid regex: '**
  String get invalidRegex;

  /// No description provided for @addingBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Adding bookmarks...'**
  String get addingBookmarks;

  /// No description provided for @finishedWriting.
  ///
  /// In en, this message translates to:
  /// **'Finished writing'**
  String get finishedWriting;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @trimLineWhitespace.
  ///
  /// In en, this message translates to:
  /// **'Trim whitespace'**
  String get trimLineWhitespace;

  /// No description provided for @tocHierarchy.
  ///
  /// In en, this message translates to:
  /// **'TOC Hierarchy'**
  String get tocHierarchy;

  /// No description provided for @unrecognized.
  ///
  /// In en, this message translates to:
  /// **'[UNRECOGNIZED]'**
  String get unrecognized;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @markedPage.
  ///
  /// In en, this message translates to:
  /// **'Marked Page'**
  String get markedPage;

  /// No description provided for @actualPage.
  ///
  /// In en, this message translates to:
  /// **'Actual Page'**
  String get actualPage;

  /// No description provided for @extractOutline.
  ///
  /// In en, this message translates to:
  /// **'Extract Outline'**
  String get extractOutline;

  /// No description provided for @outlineExtracted.
  ///
  /// In en, this message translates to:
  /// **'Outline extracted successfully'**
  String get outlineExtracted;

  /// No description provided for @resetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get resetToDefaults;

  /// No description provided for @resetDefaultsDone.
  ///
  /// In en, this message translates to:
  /// **'Defaults restored'**
  String get resetDefaultsDone;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @noPdfOutline.
  ///
  /// In en, this message translates to:
  /// **'No outline found in this PDF'**
  String get noPdfOutline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
