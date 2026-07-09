import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/pages/auth/login/login_page.dart';
import 'package:trupe_sound/pages/auth/provider/auth_provider.dart';
import 'package:trupe_sound/pages/auth/provider/auth_router_refresh.dart';
import 'package:trupe_sound/pages/auth/register/register_page.dart';
import 'package:trupe_sound/pages/base_page.dart';
import 'package:trupe_sound/pages/page_not_found.dart';
import 'package:trupe_sound/pages/plays/plays_page.dart';
import 'package:trupe_sound/pages/plays/new_play/new_play.dart';
import 'package:trupe_sound/pages/soundscape/soundscape_page.dart';
import 'package:trupe_sound/pages/sound_library/sound_library_page.dart';
import 'package:trupe_sound/pages/soundscape/soundscape_play_page.dart';
import 'package:trupe_sound/pages/system/system_overview_page.dart';

part 'router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // `ref.read`, not `watch`: the GoRouter instance must be created once and
  // stay stable. `refreshListenable` (not a `watch` dependency) is what
  // tells go_router to re-run `redirect` when auth state changes — watching
  // authRouterRefreshProvider here would instead rebuild this whole provider
  // and hand the widget tree a brand-new GoRouter, remounting every page.
  return GoRouter(
    initialLocation: '/plays',
    errorBuilder: (context, state) => const PageNotFound(),
    debugLogDiagnostics: false, // Útil para ver as rotas no console
    refreshListenable: ref.read(authRouterRefreshProvider),
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).value ?? false;
      final isAuthRoute =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/plays';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
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
