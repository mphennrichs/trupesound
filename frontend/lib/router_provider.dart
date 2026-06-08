import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/pages/base_page.dart';
import 'package:trupe_sound/pages/page_not_found.dart';
import 'package:trupe_sound/pages/plays/plays_page.dart';
import 'package:trupe_sound/pages/plays/new_play/new_play.dart';
import 'package:trupe_sound/pages/soundscape/soundscape_page.dart';
import 'package:trupe_sound/pages/sound_library/sound_library_page.dart';
import 'package:trupe_sound/pages/soundscape/soundscape_play_page.dart';
import 'package:trupe_sound/pages/system/system_overview_page.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/plays',
    errorBuilder: (context, state) => const PageNotFound(),
    debugLogDiagnostics: false, // Útil para ver as rotas no console
    redirect: (context, state) {
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BasePage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: NavigationPage.plays.path,
                name: NavigationPage.plays.name,
                builder: (context, state) => const PlaysPage(),
                routes: [
                  GoRoute(
                    path: NavigationPage.newPlay.path,
                    name: NavigationPage.newPlay.name,
                    builder: (context, state) => const NewPlayPage(),
                  ),
                  GoRoute(
                    path: NavigationPage.editPlay.path,
                    name: NavigationPage.editPlay.name,
                    builder: (context, state) {
                      final playId = int.parse(state.pathParameters['playId']!);
                      return NewPlayPage(playId: playId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: NavigationPage.soundscape.path,
                name: NavigationPage.soundscape.name,
                builder: (context, state) => const SoundscapePage(),
                routes: [
                  GoRoute(
                    path: NavigationPage.playSoundscape.path,
                    name: NavigationPage.playSoundscape.name,
                    builder: (context, state) {
                      final playId = int.parse(state.pathParameters['playId']!);
                      return SoundscapePlayPage(playId: playId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: NavigationPage.soundLibrary.path,
                name: NavigationPage.soundLibrary.name,
                builder: (context, state) => const SoundLibraryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: NavigationPage.system.path,
                name: NavigationPage.system.name,
                builder: (context, state) => const SystemOverviewPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
