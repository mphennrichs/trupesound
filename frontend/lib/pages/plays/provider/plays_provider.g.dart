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

String _$playsHash() => r'3474ba189322f33dcf332dcd63c3c1a05c3d36e0';

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
