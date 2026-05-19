// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PanicAction)
final panicActionProvider = PanicActionProvider._();

final class PanicActionProvider extends $NotifierProvider<PanicAction, void> {
  PanicActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panicActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panicActionHash();

  @$internal
  @override
  PanicAction create() => PanicAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$panicActionHash() => r'7d1ea759fc7ec73c4b231b63afe4a6b5f2cc0f7d';

abstract class _$PanicAction extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
