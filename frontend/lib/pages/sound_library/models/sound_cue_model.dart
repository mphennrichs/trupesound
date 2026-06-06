enum PlayMode { once, repeat }

class SoundCueModel {
  final int id;
  final int line;
  final String hotkey;
  final PlayMode mode;
  final String soundId;
  final DateTime createdAt;

  SoundCueModel({
    required this.id,
    required this.line,
    required this.hotkey,
    required this.mode,
    required this.soundId,
    required this.createdAt,
  });

  factory SoundCueModel.fromJson(Map<String, dynamic> json) => SoundCueModel(
    id: json['id'] as int,
    line: json['line'] as int,
    hotkey: json['hotkey'] as String,
    mode: json['mode'] == 'repeat' ? PlayMode.repeat : PlayMode.once,
    soundId: json['soundId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'line': line,
    'hotkey': hotkey,
    'mode': mode == PlayMode.repeat ? 'repeat' : 'once',
    'soundId': soundId,
    'createdAt': createdAt.toIso8601String(),
  };

  SoundCueModel copyWith({
    int? id,
    int? line,
    String? hotkey,
    PlayMode? mode,
    String? soundId,
    DateTime? createdAt,
  }) {
    return SoundCueModel(
      id: id ?? this.id,
      line: line ?? this.line,
      hotkey: hotkey ?? this.hotkey,
      mode: mode ?? this.mode,
      soundId: soundId ?? this.soundId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
