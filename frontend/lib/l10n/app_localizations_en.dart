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
  String get back => 'Back';

  @override
  String get plays => 'Plays';

  @override
  String get soundLibrary => 'Sound Library';
}
