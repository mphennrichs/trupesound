import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/base_page.dart';
import 'package:trupe_sound/pages/page_not_found.dart';
import 'package:trupe_sound/pages/plays/plays.dart';
import 'package:trupe_sound/pages/sound_library/sound_library.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/plays',
    errorBuilder: (context, state) => const PageNotFound(),
    debugLogDiagnostics: false, // Útil para ver as rotas no console
    redirect: (context, state) {
      // Remove or correct the unconditional redirect.
      // If you want to redirect the root to /plays, check the state.matchedLocation
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
                path: '/plays',
                name: 'plays',
                builder: (context, state) =>
                    const Plays(), //TODO: this is plays
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sound-library',
                name: 'sound-library',
                builder: (context, state) =>
                    const SoundLibrary(), //TODO: this is sound library
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
