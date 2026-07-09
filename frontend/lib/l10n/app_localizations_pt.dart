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
  String get soundLibraryDescription => 'Gerencie todos os recursos de áudio para suas produções';

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

  @override
  String get selectIcon => 'Selecionar Ícone';

  @override
  String get editIcon => 'Editar Ícone';

  @override
  String get editColor => 'Editar Cor';

  @override
  String get edit => 'Editar';

  @override
  String get selectBannerColor => 'Selecionar cor do banner';

  @override
  String cue(int number) {
    String _temp0 = intl.Intl.pluralLogic(
      number,
      locale: localeName,
      other: '$number Deixas',
      one: '1 Deixa',
      zero: '0 Deixas',
    );
    return '$_temp0';
  }

  @override
  String get singleCue => 'Deixa';

  @override
  String get soundCues => 'Deixas';

  @override
  String get lastModified => 'Modificado';

  @override
  String get editPlayFormTitle => 'Editar Peça';

  @override
  String get editPlayFormDescription => '';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Apagar';

  @override
  String get deletePlayConfirmationMessage => 'Tem certeza que deseja apagar esta peça? Esta ação não pode ser desfeita.';

  @override
  String get deleteSoundConfirmationMessage => 'Tem certeza que deseja apagar este efeito? Esta ação não pode ser desfeita.';

  @override
  String get previewColumn => 'Amostra';

  @override
  String get soundNameColumn => 'Nome';

  @override
  String get categoryColumn => 'Categoria';

  @override
  String get durationColumn => 'Duração';

  @override
  String get actionsColumn => 'Ações';

  @override
  String showingSounds(int start, int end, int total) {
    return 'Exibindo $start-$end de $total efeitos';
  }

  @override
  String get effect => 'Efeito';

  @override
  String get ambient => 'Ambiente';

  @override
  String get song => 'Música';

  @override
  String get all => 'Todos';

  @override
  String get addSound => 'Adicionar Som';

  @override
  String get dragAndDrop => 'Arraste e Solte o arquivo de áudio aqui...';

  @override
  String get fileTypes => 'WAV, MP3, OGG ou AIFF (max 50MB)';

  @override
  String get browseFiles => 'Procurar Arquivos';

  @override
  String get soundNameHint => 'ex. Chuva de Raios 01';

  @override
  String get soundscape => 'Sonoplastia';

  @override
  String get soundscapeDescription => 'Prepare a sonoplastia da sua peça.';

  @override
  String get noPlays => 'Você ainda não tem nenhuma peça cadastrada.';

  @override
  String get hotkey => 'Atalho';

  @override
  String get repeat => 'Repetir';

  @override
  String get once => 'Uma vez';

  @override
  String get active => 'Ativo';

  @override
  String get pressForHotkey => 'Pressione uma tecla para usar como atalho';

  @override
  String get system => 'Sistema';

  @override
  String get systemTitle => 'Dados do Sistema';

  @override
  String get systemDescription => 'Visão geral da aplicação.';

  @override
  String get applicationID => 'ID da Aplicação';

  @override
  String get applicationIDDescription => 'Identificador únicao da instalação, para uso em multi-tenant.';

  @override
  String get totalPlays => 'Total de Peças';

  @override
  String get totalSounds => 'Total de Sons';

  @override
  String get soundsPerCategory => 'Sons por Categoria';

  @override
  String get storageInfoTitle => 'Armazenamento';

  @override
  String get storageInfoDescription => 'Por padrão, os sons são armazenados em um serviço de nuvem compatível com S3 (SeaweedFS). O armazenamento local está disponível para desenvolvimento — defina STORAGE_LOCAL_FOLDER no ambiente do backend para usá-lo.';

  @override
  String get changeFile => 'Trocar arquivo';

  @override
  String get uploading => 'Enviando...';

  @override
  String get uploadComplete => 'Envio concluído';

  @override
  String get localFolder => 'Pasta Local';

  @override
  String get localFolderHint => 'Endereço da sua pasta local de sons.';

  @override
  String get syncSounds => 'Sincronizar Sons';

  @override
  String get hotkeyInUse => 'já está em uso. Pressione uma tecla diferente.';

  @override
  String get trimStart => 'Início';

  @override
  String get trimEnd => 'Fim';

  @override
  String get cueDuration => 'Duração do Cue';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginDescription => 'Acesse sua conta do TrupeSound.';

  @override
  String get registerTitle => 'Criar conta';

  @override
  String get registerDescription => 'Cadastre um novo usuário nesta instância do TrupeSound.';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nameHint => 'ex: Maria Silva';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'voce@exemplo.com';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get passwordHint => '••••••••';

  @override
  String get passwordMinLengthHint => 'A senha deve ter no mínimo 6 caracteres.';

  @override
  String get loginButton => 'Entrar';

  @override
  String get registerButton => 'Criar conta';

  @override
  String get dontHaveAccount => 'Não tem uma conta? Cadastre-se';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta? Entrar';

  @override
  String get invalidCredentials => 'Email ou senha incorretos.';

  @override
  String get emailAlreadyRegistered => 'Este email já está cadastrado.';

  @override
  String get genericError => 'Algo deu errado. Tente novamente.';

  @override
  String get accountSectionTitle => 'Conta';

  @override
  String get logoutDescription => 'Sair da sua conta neste dispositivo.';

  @override
  String get logoutButton => 'Sair';

  @override
  String get logoutConfirmTitle => 'Sair';

  @override
  String get logoutConfirmMessage => 'Tem certeza que deseja sair?';
}
