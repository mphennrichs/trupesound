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

String _$soundRepositoryHash() => r'7870e736b20a88c81c234c49910fa041a9cc8b08';

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
