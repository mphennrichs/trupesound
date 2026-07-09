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
  String get singleCue => 'Cue';

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
  String showingSounds(int start, int end, int total) {
    return 'Showing $start-$end of $total effects';
  }

  @override
  String get effect => 'Effect';

  @override
  String get ambient => 'Ambient';

  @override
  String get song => 'Song';

  @override
  String get all => 'All';

  @override
  String get addSound => 'Add Sound';

  @override
  String get dragAndDrop => 'Drag and Drop audio file here...';

  @override
  String get fileTypes => 'WAV, MP3, OGG or AIFF (max 50MB)';

  @override
  String get browseFiles => 'Browse Files';

  @override
  String get soundNameHint => 'e.g. Ambient Rainstorm 01';

  @override
  String get soundscape => 'Soundscape';

  @override
  String get soundscapeDescription => 'Prepare the soundscape for your play.';

  @override
  String get noPlays => 'You don\'t have any plays yet.';

  @override
  String get hotkey => 'Hotkey';

  @override
  String get repeat => 'Repeat';

  @override
  String get once => 'Once';

  @override
  String get active => 'Active';

  @override
  String get pressForHotkey => 'Press a key to set hotkey';

  @override
  String get system => 'System';

  @override
  String get systemTitle => 'Application Data';

  @override
  String get systemDescription => 'Application Overview.';

  @override
  String get applicationID => 'Application ID';

  @override
  String get applicationIDDescription => 'Unique session identifier for multi-tenant strategy';

  @override
  String get totalPlays => 'Total Plays';

  @override
  String get totalSounds => 'Total Sounds';

  @override
  String get soundsPerCategory => 'Sounds per Category';

  @override
  String get storageInfoTitle => 'Storage';

  @override
  String get storageInfoDescription => 'By default, sounds are stored in a cloud S3-compatible service (SeaweedFS). Local storage is available for development — set STORAGE_LOCAL_FOLDER in the backend environment to use it.';

  @override
  String get changeFile => 'Change file';

  @override
  String get uploading => 'Uploading...';

  @override
  String get uploadComplete => 'Upload complete';

  @override
  String get localFolder => 'Local Folder';

  @override
  String get localFolderHint => 'Path to your local sound folder.';

  @override
  String get syncSounds => 'Sync Sounds';

  @override
  String get hotkeyInUse => 'is already in use. Press a different key.';

  @override
  String get trimStart => 'Start';

  @override
  String get trimEnd => 'End';

  @override
  String get cueDuration => 'Cue Duration';

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginDescription => 'Sign in to your TrupeSound account.';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerDescription => 'Register a new user for this TrupeSound instance.';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'e.g. Maria Silva';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameHint => 'e.g. maria.silva';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get emailOrUsernameLabel => 'Email or username';

  @override
  String get emailOrUsernameHint => 'you@example.com or username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get passwordMinLengthHint => 'Password must be at least 6 characters.';

  @override
  String get loginButton => 'Log in';

  @override
  String get registerButton => 'Create account';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get invalidCredentials => 'Incorrect email or password.';

  @override
  String get emailAlreadyRegistered => 'This email is already registered.';

  @override
  String get usernameAlreadyRegistered => 'This username is already taken.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get logoutDescription => 'Sign out of your account on this device.';

  @override
  String get logoutButton => 'Log out';

  @override
  String get logoutConfirmTitle => 'Log out';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';
}
