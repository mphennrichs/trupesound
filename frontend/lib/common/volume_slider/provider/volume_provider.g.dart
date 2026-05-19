// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Volume)
final volumeProvider = VolumeProvider._();

final class VolumeProvider extends $NotifierProvider<Volume, double> {
  VolumeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'volumeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$volumeHash();

  @$internal
  @override
  Volume create() => Volume();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$volumeHash() => r'748f96167044da4c795cbf5aa65ce62d207f727f';

abstract class _$Volume extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
