import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/soundscape/provider/sound_playback_provider.dart';

part 'panic_provider.g.dart';

@riverpod
class PanicAction extends _$PanicAction {
  @override
  void build() {}

  Future<void> execute() async {
    await ref.read(soundPlaybackProvider.notifier).stopAll();
  }
}
