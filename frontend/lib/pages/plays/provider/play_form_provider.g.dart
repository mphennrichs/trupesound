// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayFormController)
final playFormControllerProvider = PlayFormControllerProvider._();

final class PlayFormControllerProvider
    extends $NotifierProvider<PlayFormController, PlayFormState> {
  PlayFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playFormControllerHash();

  @$internal
  @override
  PlayFormController create() => PlayFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayFormState>(value),
    );
  }
}

String _$playFormControllerHash() =>
    r'bedba6986d4e374773b7efbdcef66d4104b672bb';

abstract class _$PlayFormController extends $Notifier<PlayFormState> {
  PlayFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayFormState, PlayFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayFormState, PlayFormState>,
              PlayFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
