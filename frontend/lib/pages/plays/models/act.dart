import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';

class Act {
  final int number;
  final String name;
  final String script;
  final List<SoundCueModel> cues;

  const Act({
    required this.number,
    required this.name,
    required this.script,
    required this.cues,
  });
}
