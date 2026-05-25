// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pageNotFound => 'Page not found.';

  @override
  String get pageNotFoundDescription => 'Sorry, the page that you are looking for doesn\'t exists.';

  @override
  String get playsTitle => 'Plays';

  @override
  String get playsDescription => 'Manage your active productions.';

  @override
  String get soundLibraryTitle => 'Sound Library';

  @override
  String get soundLibraryDescription => 'Access all audio assets for yout productions';

  @override
  String get createNewPlay => 'Create New Play';

  @override
  String get newPlayFormTitle => 'New Play';

  @override
  String get newPlayFormDescription => 'Organize your script into acts for more precise soundscape management.';

  @override
  String get back => 'Back';

  @override
  String panicStop(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'esc': 'Panic Stop (ESC)',
        'other': 'Panic Stop',
      },
    );
    return '$_temp0';
  }

  @override
  String get playTitleLabel => 'Play Title';

  @override
  String get playTitleHint => 'e.g.: Macbeth, Cyrano de Bergerac';

  @override
  String get playAuthorLabel => 'Author';

  @override
  String get playAuthorHint => 'e.g. Tenesse Willams';

  @override
  String get scriptOrganization => 'Script Organization';

  @override
  String get addAct => 'Add Act';

  @override
  String get act => 'Act';

  @override
  String pasteActHint(String act, String number) {
    return 'Paste $act $number script here...';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get createAndStartEditing => 'Create & Start editing';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get editIcon => 'Edit Icon';

  @override
  String get editColor => 'Edit Color';

  @override
  String get edit => 'Edit';

  @override
  String get selectBannerColor => 'Select banner color';

  @override
  String cue(int number) {
    String _temp0 = intl.Intl.pluralLogic(
      number,
      locale: localeName,
      other: '$number Cues',
      one: '1 Cue',
      zero: '0 Cues',
    );
    return '$_temp0';
  }

  @override
  String get soundCues => 'Sound Cues';

  @override
  String get lastModified => 'Last Modified';

  @override
  String get editPlayFormTitle => 'Edit Play';

  @override
  String get editPlayFormDescription => '';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get deletePlayConfirmationMessage => 'Are you sure you want to delete this play? This action cannot be undone.';

  @override
  String get deleteSoundConfirmationMessage => 'Are you sure you want to delete this effect? This action cannot be undone.';

  @override
  String get previewColumn => 'Preview';

  @override
  String get soundNameColumn => 'Sound Name';

  @override
  String get categoryColumn => 'Category';

  @override
  String get durationColumn => 'Duration';

  @override
  String get actionsColumn => 'Actions';

  @override
  String showingAssets(int start, int end, int total) {
    return 'Showing $start-$end of $total assets';
  }

  @override
  String get effect => 'Effect';

  @override
  String get ambient => 'Ambient';

  @override
  String get song => 'Song';

  @override
  String get all => 'All';
}
