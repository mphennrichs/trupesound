import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';

class ScriptLine {
  final int lineNumber;
  final String text;

  const ScriptLine({required this.lineNumber, required this.text});

  factory ScriptLine.fromJson(Map<String, dynamic> json) => ScriptLine(
    lineNumber: json['lineNumber'] as int,
    text: json['text'] as String,
  );

  Map<String, dynamic> toJson() => {'lineNumber': lineNumber, 'text': text};

  ScriptLine copyWith({int? lineNumber, String? text}) {
    return ScriptLine(
      lineNumber: lineNumber ?? this.lineNumber,
      text: text ?? this.text,
    );
  }
}

class ActModel {
  final int id;
  final int number;
  final String name;
  final List<ScriptLine> script;
  final List<SoundCueModel> cues;

  const ActModel({
    this.id = 0,
    required this.number,
    required this.name,
    required this.script,
    required this.cues,
  });

  factory ActModel.fromJson(Map<String, dynamic> json) => ActModel(
    id: json['id'] as int,
    number: json['number'] as int,
    name: json['name'] as String,
    script:
        (json['script'] as List)
            .map((e) => ScriptLine.fromJson(e as Map<String, dynamic>))
            .toList(),
    cues: [],
  );

  Map<String, dynamic> toJson() => {
    'number': number,
    'name': name,
    'script': script.map((s) => s.toJson()).toList(),
  };

  ActModel copyWith({
    int? id,
    int? number,
    String? name,
    List<ScriptLine>? script,
    List<SoundCueModel>? cues,
  }) {
    return ActModel(
      id: id ?? this.id,
      number: number ?? this.number,
      name: name ?? this.name,
      script: script ?? this.script,
      cues: cues ?? this.cues,
    );
  }
}
