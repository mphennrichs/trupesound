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
  String get soundLibraryDescription => 'Manage you sound effects';

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
  String get playAuthorDirectorLabel => 'Author/Director';

  @override
  String get playAuthorDirectorHint => 'e.g. Tenesse Willams';

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
}
