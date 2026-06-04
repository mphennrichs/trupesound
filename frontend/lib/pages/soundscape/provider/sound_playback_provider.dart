import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sound_playback_provider.g.dart';

class PlaybackState {
  final Set<int> playingIds;
  final Map<int, bool> repeatSettings; // cueId -> isRepeat

  PlaybackState({required this.playingIds, required this.repeatSettings});
}

@riverpod
class SoundPlayback extends _$SoundPlayback {
  @override
  PlaybackState build() {
    return PlaybackState(playingIds: {}, repeatSettings: {});
  }

  void togglePlayback(int cueId) {
    final isPlaying = state.playingIds.contains(cueId);
    final newIds = Set<int>.from(state.playingIds);

    if (isPlaying) {
      newIds.remove(cueId);
    } else {
      newIds.add(cueId);
    }

    state = PlaybackState(
      playingIds: newIds,
      repeatSettings: state.repeatSettings,
    );
  }

  void setRepeat(int cueId, bool repeat) {
    final newSettings = Map<int, bool>.from(state.repeatSettings);
    newSettings[cueId] = repeat;
    state = PlaybackState(
      playingIds: state.playingIds,
      repeatSettings: newSettings,
    );
  }

  void stopAll() => state = PlaybackState(
    playingIds: {},
    repeatSettings: state.repeatSettings,
  );
}
