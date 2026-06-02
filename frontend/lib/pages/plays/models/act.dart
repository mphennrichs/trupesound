import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';

class ScriptLine {
  final int lineNumber;
  final String text;

  const ScriptLine({required this.lineNumber, required this.text});
}

class ActModel {
  final int number;
  final String name;
  final List<ScriptLine> script;
  final List<SoundCueModel> cues;

  const ActModel({
    required this.number,
    required this.name,
    required this.script,
    required this.cues,
  });
}
