import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/auth_storage_provider.dart';
import 'package:trupe_sound/pages/auth/service/auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<bool> build() async {
    final token = await ref.watch(authStorageProvider.future);
    return token != null;
  }

  Future<void> login(String email, String password) async {
    // Errors are intentionally left uncaught for the caller to handle in the
    // UI, but must not be assigned to `state` — this notifier is watched by
    // the router, and turning `state` into AsyncError would rebuild the
    // GoRouter mid-submit, unmounting the very form handling the error.
    final result = await ref.read(authServiceProvider).login(email, password);
    await ref.read(authStorageProvider.notifier).saveToken(result.accessToken);
    state = const AsyncData(true);
  }

  Future<void> register(String name, String email, String password) async {
    final result = await ref.read(authServiceProvider).register(name, email, password);
    await ref.read(authStorageProvider.notifier).saveToken(result.accessToken);
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    await ref.read(authStorageProvider.notifier).clearToken();
    state = const AsyncData(false);
  }
}
