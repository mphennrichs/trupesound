import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found.'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'Sorry, the page that you are looking for doesn\'t exists.'**
  String get pageNotFoundDescription;

  /// No description provided for @playsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plays'**
  String get playsTitle;

  /// No description provided for @playsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your active productions.'**
  String get playsDescription;

  /// No description provided for @soundLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Library'**
  String get soundLibraryTitle;

  /// No description provided for @soundLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Access all audio assets for yout productions'**
  String get soundLibraryDescription;

  /// No description provided for @createNewPlay.
  ///
  /// In en, this message translates to:
  /// **'Create New Play'**
  String get createNewPlay;

  /// No description provided for @newPlayFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New Play'**
  String get newPlayFormTitle;

  /// No description provided for @newPlayFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Organize your script into acts for more precise soundscape management.'**
  String get newPlayFormDescription;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @panicStop.
  ///
  /// In en, this message translates to:
  /// **'{type, select, esc{Panic Stop (ESC)} other{Panic Stop}}'**
  String panicStop(String type);

  /// No description provided for @playTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Play Title'**
  String get playTitleLabel;

  /// No description provided for @playTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g.: Macbeth, Cyrano de Bergerac'**
  String get playTitleHint;

  /// No description provided for @playAuthorLabel.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get playAuthorLabel;

  /// No description provided for @playAuthorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tenesse Willams'**
  String get playAuthorHint;

  /// No description provided for @scriptOrganization.
  ///
  /// In en, this message translates to:
  /// **'Script Organization'**
  String get scriptOrganization;

  /// No description provided for @addAct.
  ///
  /// In en, this message translates to:
  /// **'Add Act'**
  String get addAct;

  /// No description provided for @act.
  ///
  /// In en, this message translates to:
  /// **'Act'**
  String get act;

  /// No description provided for @pasteActHint.
  ///
  /// In en, this message translates to:
  /// **'Paste {act} {number} script here...'**
  String pasteActHint(String act, String number);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @createAndStartEditing.
  ///
  /// In en, this message translates to:
  /// **'Create & Start editing'**
  String get createAndStartEditing;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @editIcon.
  ///
  /// In en, this message translates to:
  /// **'Edit Icon'**
  String get editIcon;

  /// No description provided for @editColor.
  ///
  /// In en, this message translates to:
  /// **'Edit Color'**
  String get editColor;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @selectBannerColor.
  ///
  /// In en, this message translates to:
  /// **'Select banner color'**
  String get selectBannerColor;

  /// No description provided for @cue.
  ///
  /// In en, this message translates to:
  /// **'{number, plural, =0{0 Cues} =1{1 Cue} other{{number} Cues}}'**
  String cue(int number);

  /// No description provided for @soundCues.
  ///
  /// In en, this message translates to:
  /// **'Sound Cues'**
  String get soundCues;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last Modified'**
  String get lastModified;

  /// No description provided for @editPlayFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Play'**
  String get editPlayFormTitle;

  /// No description provided for @editPlayFormDescription.
  ///
  /// In en, this message translates to:
  /// **''**
  String get editPlayFormDescription;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletePlayConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this play? This action cannot be undone.'**
  String get deletePlayConfirmationMessage;

  /// No description provided for @deleteSoundConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this effect? This action cannot be undone.'**
  String get deleteSoundConfirmationMessage;

  /// No description provided for @previewColumn.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewColumn;

  /// No description provided for @soundNameColumn.
  ///
  /// In en, this message translates to:
  /// **'Sound Name'**
  String get soundNameColumn;

  /// No description provided for @categoryColumn.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryColumn;

  /// No description provided for @durationColumn.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationColumn;

  /// No description provided for @actionsColumn.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsColumn;

  /// No description provided for @showingSounds.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}-{end} of {total} effects'**
  String showingSounds(int start, int end, int total);

  /// No description provided for @effect.
  ///
  /// In en, this message translates to:
  /// **'Effect'**
  String get effect;

  /// No description provided for @ambient.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get ambient;

  /// No description provided for @song.
  ///
  /// In en, this message translates to:
  /// **'Song'**
  String get song;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @addSound.
  ///
  /// In en, this message translates to:
  /// **'Add Sound'**
  String get addSound;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
