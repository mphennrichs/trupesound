// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_config_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storageConfigService)
final storageConfigServiceProvider = StorageConfigServiceProvider._();

final class StorageConfigServiceProvider
    extends
        $FunctionalProvider<
          StorageConfigService,
          StorageConfigService,
          StorageConfigService
        >
    with $Provider<StorageConfigService> {
  StorageConfigServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageConfigServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageConfigServiceHash();

  @$internal
  @override
  $ProviderElement<StorageConfigService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StorageConfigService create(Ref ref) {
    return storageConfigService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StorageConfigService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StorageConfigService>(value),
    );
  }
}

String _$storageConfigServiceHash() =>
    r'c9360a183f3c895cb491a2b50bda686492e3e039';
