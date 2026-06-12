import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/volume_slider/provider/volume_provider.dart';

part 'audio_player_provider.g.dart';

class AudioPlayerState {
  final int? playingId;
  final PlayerState playerState;
  final bool isLooping;
  final Duration position;

  const AudioPlayerState({
    this.playingId,
    this.playerState = PlayerState.stopped,
    this.isLooping = false,
    this.position = Duration.zero,
  });

  bool get isPlaying => playerState == PlayerState.playing;
  bool isPlayingId(int id) => playingId == id && isPlaying;
}

class _PlayRequest {
  final int id;
  final String url;
  final int startMs;
  final int? endMs;
  final bool loop;

  const _PlayRequest({
    required this.id,
    required this.url,
    required this.startMs,
    this.endMs,
    required this.loop,
  });
}

@Riverpod(keepAlive: true)
class AudioPlayerNotifier extends _$AudioPlayerNotifier {
  final AudioPlayer _player = AudioPlayer();
  _PlayRequest? _current;

  @override
  AudioPlayerState build() {
    _player.onPlayerStateChanged.listen((ps) {
      state = AudioPlayerState(playingId: state.playingId, playerState: ps, isLooping: state.isLooping, position: state.position);
    });

    _player.onPositionChanged.listen((pos) {
      state = AudioPlayerState(playingId: state.playingId, playerState: state.playerState, isLooping: state.isLooping, position: pos);
    });

    _player.onPlayerComplete.listen((_) {
      final req = _current;
      if (req != null && req.loop) {
        _playFrom(req);
      }
    });

    ref.listen(volumeProvider, (_, volume) {
      _player.setVolume(volume);
    });

    ref.onDispose(_player.dispose);

    return const AudioPlayerState();
  }

  Future<void> play(
    int id,
    String url, {
    int startMs = 0,
    int? endMs,
    bool loop = false,
  }) async {
    if (state.isPlayingId(id)) {
      await _player.stop();
      _current = null;
      return;
    }

    _current = _PlayRequest(id: id, url: url, startMs: startMs, endMs: endMs, loop: loop);
    state = AudioPlayerState(playingId: id, playerState: PlayerState.playing, isLooping: loop);
    await _playFrom(_current!);
  }

  Future<void> _playFrom(_PlayRequest req) async {
    await _player.stop();
    await _player.setVolume(ref.read(volumeProvider));

    final source = req.url.startsWith('http') ? UrlSource(req.url) : DeviceFileSource(req.url);
    await _player.play(source);

    if (req.startMs > 0) {
      await _player.seek(Duration(milliseconds: req.startMs));
    }

    if (req.endMs != null) {
      final trimDuration = Duration(milliseconds: req.endMs! - req.startMs);
      Future.delayed(trimDuration, () async {
        if (_current?.id == req.id) {
          if (req.loop) {
            await _playFrom(req);
          } else {
            await _player.stop();
          }
        }
      });
    }
  }

  Future<void> stop() async {
    _current = null;
    await _player.stop();
    state = AudioPlayerState(playingId: state.playingId, playerState: PlayerState.stopped, isLooping: false, position: Duration.zero);
  }
}
