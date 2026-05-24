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
  String get playsTitle => 'Peças';

  @override
  String get playsDescription => 'Gerencie suas produções ativas.';

  @override
  String get soundLibraryTitle => 'Biblioteca de Sons';

  @override
  String get soundLibraryDescription => 'Gerencie seus efeitos sonoros.';

  @override
  String get createNewPlay => 'Criar Nova Peça';

  @override
  String get newPlayFormTitle => 'Nova Peça';

  @override
  String get newPlayFormDescription => 'Organize seu roteiro em atos para um gerenciamento mais preciso da sonoplastia.';

  @override
  String get back => 'Voltar';

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

  @override
  String get playTitleLabel => 'Título da Peça';

  @override
  String get playTitleHint => 'ex. Caixa Mágica, Regra de três';

  @override
  String get playAuthorLabel => 'Autor(a)';

  @override
  String get playAuthorHint => 'ex. Luciana Coelho';

  @override
  String get scriptOrganization => 'Organização do Script';

  @override
  String get addAct => 'Adicionar Ato';

  @override
  String get act => 'Ato';

  @override
  String pasteActHint(String act, String number) {
    return 'Cole o script do $act $number aqui...';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get createAndStartEditing => 'Criar e Começar a editar';
}
