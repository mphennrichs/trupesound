// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(soundService)
final soundServiceProvider = SoundServiceProvider._();

final class SoundServiceProvider
    extends $FunctionalProvider<SoundService, SoundService, SoundService>
    with $Provider<SoundService> {
  SoundServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundServiceHash();

  @$internal
  @override
  $ProviderElement<SoundService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SoundService create(Ref ref) {
    return soundService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundService>(value),
    );
  }
}

String _$soundServiceHash() => r'36bf5e930a39bbf8779e9e63444e06ff73389f22';
