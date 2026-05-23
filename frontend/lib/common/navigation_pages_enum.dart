enum NavigationPage {
  plays,
  soundLibrary,
  newPlay;

  String get path => switch (this) {
    NavigationPage.plays => '/plays',
    NavigationPage.soundLibrary => '/sound-library',
    NavigationPage.newPlay => 'new-play',
  };
}
