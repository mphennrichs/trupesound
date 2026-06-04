enum NavigationPage {
  plays,
  soundLibrary,
  newPlay,
  soundscape,
  playSoundscape,
  editPlay,
  system;

  String get path => switch (this) {
    NavigationPage.plays => '/plays',
    NavigationPage.soundLibrary => '/sound-library',
    NavigationPage.newPlay => 'new-play',
    NavigationPage.soundscape => '/soundscape',
    NavigationPage.playSoundscape => ':playId/soundscape',
    NavigationPage.editPlay => ':playId/edit',
    NavigationPage.system => '/system',
  };
}
