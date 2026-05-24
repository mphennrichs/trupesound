// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plays_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Plays)
final playsProvider = PlaysProvider._();

final class PlaysProvider extends $AsyncNotifierProvider<Plays, List<Play>> {
  PlaysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playsHash();

  @$internal
  @override
  Plays create() => Plays();
}

String _$playsHash() => r'dfc773356e6d28d45f703c1d3c95f3f8db462f6b';

abstract class _$Plays extends $AsyncNotifier<List<Play>> {
  FutureOr<List<Play>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Play>>, List<Play>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Play>>, List<Play>>,
              AsyncValue<List<Play>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
