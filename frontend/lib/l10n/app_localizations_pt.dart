// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get pageNotFound => 'Página não encontrada.';

  @override
  String get pageNotFoundDescription => 'Desculpe, a página que você está procurando não existe.';

  @override
  String get back => 'Voltar';

  @override
  String get plays => 'Peças';

  @override
  String get soundLibrary => 'Biblioteca de Sons';

  @override
  String panicStop(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'esc': 'Parada de Emergência (ESC)',
        'other': 'Parada de Emergência',
      },
    );
    return '$_temp0';
  }
}
