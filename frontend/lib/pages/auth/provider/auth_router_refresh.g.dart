// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_router_refresh.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRouterRefresh)
final authRouterRefreshProvider = AuthRouterRefreshProvider._();

final class AuthRouterRefreshProvider
    extends
        $FunctionalProvider<
          AuthRouterRefresh,
          AuthRouterRefresh,
          AuthRouterRefresh
        >
    with $Provider<AuthRouterRefresh> {
  AuthRouterRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRouterRefreshProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRouterRefreshHash();

  @$internal
  @override
  $ProviderElement<AuthRouterRefresh> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRouterRefresh create(Ref ref) {
    return authRouterRefresh(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRouterRefresh value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRouterRefresh>(value),
    );
  }
}

String _$authRouterRefreshHash() => r'19e366c6413b4427183cf6a97ccc53d596528228';
