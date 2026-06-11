import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/audio_player_provider.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';

part 'sound_playback_provider.g.dart';

class PlaybackState {
  final Set<int> playingIds;
  final Map<int, bool> repeatSettings;

  PlaybackState({required this.playingIds, required this.repeatSettings});
}

@riverpod
class SoundPlayback extends _$SoundPlayback {
  @override
  PlaybackState build() {
    ref.listen(audioPlayerProvider, (prev, next) {
      if (!next.isPlaying && !next.isLooping && state.playingIds.isNotEmpty) {
        state = PlaybackState(
          playingIds: {},
          repeatSettings: state.repeatSettings,
        );
      }
    });

    return PlaybackState(playingIds: {}, repeatSettings: {});
  }

  Future<void> togglePlayback(int cueId, String soundId, {int? startMs, int? endMs, bool loop = false}) async {
    final sounds = ref.read(allSoundsProvider);
    final sound = sounds.where((s) => s.id.toString() == soundId).firstOrNull;
    if (sound == null) return;

    final isPlaying = state.playingIds.contains(cueId);
    final newIds = Set<int>.from(state.playingIds);

    if (isPlaying) {
      newIds.remove(cueId);
      await ref.read(audioPlayerProvider.notifier).stop();
    } else {
      final response = await ref.read(dioProvider).get<Map<String, dynamic>>('/v1/sounds/${sound.id}/play-url');
      final playUrl = (response.data?['url'] as String?) ?? sound.url;

      newIds.clear();
      newIds.add(cueId);
      await ref.read(audioPlayerProvider.notifier).play(
        sound.id,
        playUrl,
        startMs: startMs ?? 0,
        endMs: endMs,
        loop: loop,
      );
    }

    state = PlaybackState(playingIds: newIds, repeatSettings: state.repeatSettings);
  }

  void setRepeat(int cueId, bool repeat) {
    final newSettings = Map<int, bool>.from(state.repeatSettings);
    newSettings[cueId] = repeat;
    state = PlaybackState(playingIds: state.playingIds, repeatSettings: newSettings);
  }

  Future<void> stopAll() async {
    await ref.read(audioPlayerProvider.notifier).stop();
    state = PlaybackState(playingIds: {}, repeatSettings: state.repeatSettings);
  }
}
