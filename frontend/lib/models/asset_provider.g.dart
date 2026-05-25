// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AssetRepository)
final assetRepositoryProvider = AssetRepositoryProvider._();

final class AssetRepositoryProvider
    extends $AsyncNotifierProvider<AssetRepository, List<AssetModel>> {
  AssetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetRepositoryHash();

  @$internal
  @override
  AssetRepository create() => AssetRepository();
}

String _$assetRepositoryHash() => r'44954b052e0341992f8978b1ef9280b392dbac78';

abstract class _$AssetRepository extends $AsyncNotifier<List<AssetModel>> {
  FutureOr<List<AssetModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<AssetModel>>, List<AssetModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AssetModel>>, List<AssetModel>>,
              AsyncValue<List<AssetModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredAssets)
final filteredAssetsProvider = FilteredAssetsProvider._();

final class FilteredAssetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AssetModel>>,
          AsyncValue<List<AssetModel>>,
          AsyncValue<List<AssetModel>>
        >
    with $Provider<AsyncValue<List<AssetModel>>> {
  FilteredAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAssetsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<AssetModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<AssetModel>> create(Ref ref) {
    return filteredAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<AssetModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<AssetModel>>>(value),
    );
  }
}

String _$filteredAssetsHash() => r'6e6aaf47add5c890c2d5b909528d4cefc055642e';
