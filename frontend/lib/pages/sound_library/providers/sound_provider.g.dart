// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Sounds)
final soundsProvider = SoundsProvider._();

final class SoundsProvider
    extends $AsyncNotifierProvider<Sounds, List<SoundModel>> {
  SoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundsHash();

  @$internal
  @override
  Sounds create() => Sounds();
}

String _$soundsHash() => r'd00459500cbc77d0316e50f70bee3594e5eb86b3';

abstract class _$Sounds extends $AsyncNotifier<List<SoundModel>> {
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

String _$filteredSoundsHash() => r'3269ff2a11ff99d5b2ef012dfc4db6d1521f6aa8';

@ProviderFor(allSounds)
final allSoundsProvider = AllSoundsProvider._();

final class AllSoundsProvider
    extends
        $FunctionalProvider<
          List<SoundModel>,
          List<SoundModel>,
          List<SoundModel>
        >
    with $Provider<List<SoundModel>> {
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

String _$allSoundsHash() => r'58792311218973264f85b5f781423c86314beb78';

@ProviderFor(soundCountsByCategory)
final soundCountsByCategoryProvider = SoundCountsByCategoryProvider._();

final class SoundCountsByCategoryProvider
    extends
        $FunctionalProvider<
          Map<SoundCategory, int>,
          Map<SoundCategory, int>,
          Map<SoundCategory, int>
        >
    with $Provider<Map<SoundCategory, int>> {
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
