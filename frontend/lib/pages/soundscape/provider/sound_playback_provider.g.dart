// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_playback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SoundPlayback)
final soundPlaybackProvider = SoundPlaybackProvider._();

final class SoundPlaybackProvider
    extends $NotifierProvider<SoundPlayback, PlaybackState> {
  SoundPlaybackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundPlaybackProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundPlaybackHash();

  @$internal
  @override
  SoundPlayback create() => SoundPlayback();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaybackState>(value),
    );
  }
}

String _$soundPlaybackHash() => r'd6e002e9036fd68c6e4eb5ecf45c7ae60474faa2';

abstract class _$SoundPlayback extends $Notifier<PlaybackState> {
  PlaybackState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlaybackState, PlaybackState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlaybackState, PlaybackState>,
              PlaybackState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
