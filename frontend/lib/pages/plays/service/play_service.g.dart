// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playService)
final playServiceProvider = PlayServiceProvider._();

final class PlayServiceProvider
    extends $FunctionalProvider<PlayService, PlayService, PlayService>
    with $Provider<PlayService> {
  PlayServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playServiceHash();

  @$internal
  @override
  $ProviderElement<PlayService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlayService create(Ref ref) {
    return playService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayService>(value),
    );
  }
}

String _$playServiceHash() => r'a1a2e13953e11b698e7a7cf208e343bce4d5673a';
