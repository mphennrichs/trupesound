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

String _$soundRepositoryHash() => r'4efc66f536f36eced9f022c18d06ac25ef0d5a29';

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

String _$filteredSoundsHash() => r'6b771f5adcfafbf27ab29fc86d07f7116e624567';
