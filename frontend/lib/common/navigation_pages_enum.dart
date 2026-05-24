enum NavigationPage {
  plays,
  soundLibrary,
  newPlay,
  soundscape,
  editPlay;

  String get path => switch (this) {
    NavigationPage.plays => '/plays',
    NavigationPage.soundLibrary => '/sound-library',
    NavigationPage.newPlay => 'new-play',
    NavigationPage.soundscape => ':playId/soundscape',
    NavigationPage.editPlay => ':playId/edit',
  };
}
