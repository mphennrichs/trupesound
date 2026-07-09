import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/auth/provider/auth_provider.dart';

part 'auth_router_refresh.g.dart';

/// Bridges [authProvider] to [GoRouter.refreshListenable] so the router only
/// re-evaluates `redirect` when the resolved authenticated/unauthenticated
/// value actually flips — not on every transient loading/error state the
/// notifier passes through (e.g. while a login attempt is in flight).
/// Using `ref.watch(authProvider)` directly inside `redirect` would rebuild
/// the whole GoRouter (and remount the current page) on those transient
/// states too.
class AuthRouterRefresh extends ChangeNotifier {
  bool? _lastValue;

  AuthRouterRefresh(Ref ref) {
    ref.listen(authProvider, (previous, next) {
      final value = next.value;
      if (value != null && value != _lastValue) {
        _lastValue = value;
        notifyListeners();
      }
    });
  }
}

@Riverpod(keepAlive: true)
AuthRouterRefresh authRouterRefresh(Ref ref) {
  return AuthRouterRefresh(ref);
}
