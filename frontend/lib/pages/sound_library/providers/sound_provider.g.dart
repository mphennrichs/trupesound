// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SoundRepository)
final soundRepositoryProvider = SoundRepositoryProvider._();

final class SoundRepositoryProvider
    extends $AsyncNotifierProvider<SoundRepository, List<SoundModel>> {
  SoundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundRepositoryHash();

  @$internal
  @override
  SoundRepository create() => SoundRepository();
}

String _$soundRepositoryHash() => r'79fd8c4f24f88b87d203bd493714395f8a7a6553';

abstract class _$SoundRepository extends $AsyncNotifier<List<SoundModel>> {
  FutureOr<List<SoundModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SoundModel>>, List<SoundModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SoundModel>>, List<SoundModel>>,
              AsyncValue<List<SoundModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SoundCategoryFilter)
final soundCategoryFilterProvider = SoundCategoryFilterProvider._();

final class SoundCategoryFilterProvider
    extends $NotifierProvider<SoundCategoryFilter, SoundCategory> {
  SoundCategoryFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundCategoryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundCategoryFilterHash();

  @$internal
  @override
  SoundCategoryFilter create() => SoundCategoryFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SoundCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SoundCategory>(value),
    );
  }
}

String _$soundCategoryFilterHash() =>
    r'1f315196eed177152af005fad305455f0d62ea65';

abstract class _$SoundCategoryFilter extends $Notifier<SoundCategory> {
  SoundCategory build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SoundCategory, SoundCategory>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SoundCategory, SoundCategory>,
              SoundCategory,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredSounds)
final filteredSoundsProvider = FilteredSoundsProvider._();

final class FilteredSoundsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SoundModel>>,
          AsyncValue<List<SoundModel>>,
          AsyncValue<List<SoundModel>>
        >
    with $Provider<AsyncValue<List<SoundModel>>> {
  FilteredSoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredSoundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredSoundsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<SoundModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<SoundModel>> create(Ref ref) {
    return filteredSounds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<SoundModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<SoundModel>>>(value),
    );
  }
}

String _$filteredSoundsHash() => r'f490330194ed0043f8d6a790c83f82ea6c69eab7';

/// Returns all sounds from the repository, defaulting to an empty list if data is loading.

@ProviderFor(allSounds)
final allSoundsProvider = AllSoundsProvider._();

/// Returns all sounds from the repository, defaulting to an empty list if data is loading.

final class AllSoundsProvider
    extends
        $FunctionalProvider<
          List<SoundModel>,
          List<SoundModel>,
          List<SoundModel>
        >
    with $Provider<List<SoundModel>> {
  /// Returns all sounds from the repository, defaulting to an empty list if data is loading.
  AllSoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allSoundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allSoundsHash();

  @$internal
  @override
  $ProviderElement<List<SoundModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<SoundModel> create(Ref ref) {
    return allSounds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SoundModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SoundModel>>(value),
    );
  }
}

String _$allSoundsHash() => r'529ce8748077bb5bd08aa8f59c83f2f73bda6cc9';

/// Computes the quantity of sounds available for each category.

@ProviderFor(soundCountsByCategory)
final soundCountsByCategoryProvider = SoundCountsByCategoryProvider._();

/// Computes the quantity of sounds available for each category.

final class SoundCountsByCategoryProvider
    extends
        $FunctionalProvider<
          Map<SoundCategory, int>,
          Map<SoundCategory, int>,
          Map<SoundCategory, int>
        >
    with $Provider<Map<SoundCategory, int>> {
  /// Computes the quantity of sounds available for each category.
  SoundCountsByCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundCountsByCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundCountsByCategoryHash();

  @$internal
  @override
  $ProviderElement<Map<SoundCategory, int>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<SoundCategory, int> create(Ref ref) {
    return soundCountsByCategory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<SoundCategory, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<SoundCategory, int>>(value),
    );
  }
}

String _$soundCountsByCategoryHash() =>
    r'038416b15a8d8c4c80f949b3b0b6f6dd4dc3effb';
