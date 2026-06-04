// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a unique Application ID generated at startup.
/// keepAlive is set to true to ensure the ID remains constant during the app lifecycle.

@ProviderFor(applicationId)
final applicationIdProvider = ApplicationIdProvider._();

/// Provides a unique Application ID generated at startup.
/// keepAlive is set to true to ensure the ID remains constant during the app lifecycle.

final class ApplicationIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Provides a unique Application ID generated at startup.
  /// keepAlive is set to true to ensure the ID remains constant during the app lifecycle.
  ApplicationIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return applicationId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$applicationIdHash() => r'cbe336254ebeb72e32b8a054f02145736c43d25f';

/// Identifies the quantity of sounds per category using data from [soundsProvider].

@ProviderFor(soundsByCategory)
final soundsByCategoryProvider = SoundsByCategoryProvider._();

/// Identifies the quantity of sounds per category using data from [soundsProvider].

final class SoundsByCategoryProvider
    extends
        $FunctionalProvider<
          Map<SoundCategory, int>,
          Map<SoundCategory, int>,
          Map<SoundCategory, int>
        >
    with $Provider<Map<SoundCategory, int>> {
  /// Identifies the quantity of sounds per category using data from [soundsProvider].
  SoundsByCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundsByCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundsByCategoryHash();

  @$internal
  @override
  $ProviderElement<Map<SoundCategory, int>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<SoundCategory, int> create(Ref ref) {
    return soundsByCategory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<SoundCategory, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<SoundCategory, int>>(value),
    );
  }
}

String _$soundsByCategoryHash() => r'69c55271e867101512a0b63b34aeb4e3738a538d';
