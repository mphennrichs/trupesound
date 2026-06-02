// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayFormController)
final playFormControllerProvider = PlayFormControllerFamily._();

final class PlayFormControllerProvider
    extends $NotifierProvider<PlayFormController, PlayFormState> {
  PlayFormControllerProvider._({
    required PlayFormControllerFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'playFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playFormControllerHash();

  @override
  String toString() {
    return r'playFormControllerProvider'
        ''
        '($argument)';
  }

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

  @override
  bool operator ==(Object other) {
    return other is PlayFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playFormControllerHash() =>
    r'a2ab8cbaff0e2991ebc15a7af4d2ebfd47e7ade1';

final class PlayFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PlayFormController,
          PlayFormState,
          PlayFormState,
          PlayFormState,
          int?
        > {
  PlayFormControllerFamily._()
    : super(
        retry: null,
        name: r'playFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayFormControllerProvider call(int? playId) =>
      PlayFormControllerProvider._(argument: playId, from: this);

  @override
  String toString() => r'playFormControllerProvider';
}

abstract class _$PlayFormController extends $Notifier<PlayFormState> {
  late final _$args = ref.$arg as int?;
  int? get playId => _$args;

  PlayFormState build(int? playId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
