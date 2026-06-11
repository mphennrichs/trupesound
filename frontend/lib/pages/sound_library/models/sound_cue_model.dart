enum PlayMode { once, repeat }

class SoundCueModel {
  final int id;
  final int line;
  final String hotkey;
  final PlayMode mode;
  final String soundId;
  final DateTime createdAt;
  final int? startMs;
  final int? endMs;

  SoundCueModel({
    required this.id,
    required this.line,
    required this.hotkey,
    required this.mode,
    required this.soundId,
    required this.createdAt,
    this.startMs,
    this.endMs,
  });

  factory SoundCueModel.fromJson(Map<String, dynamic> json) => SoundCueModel(
    id: json['id'] as int,
    line: json['line'] as int,
    hotkey: json['hotkey'] as String,
    mode: json['mode'] == 'repeat' ? PlayMode.repeat : PlayMode.once,
    soundId: json['soundId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    startMs: (json['startMs'] as num?)?.toInt(),
    endMs: (json['endMs'] as num?)?.toInt(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'line': line,
    'hotkey': hotkey,
    'mode': mode == PlayMode.repeat ? 'repeat' : 'once',
    'soundId': soundId,
    'createdAt': createdAt.toIso8601String(),
    if (startMs != null) 'startMs': startMs,
    if (endMs != null) 'endMs': endMs,
  };

  SoundCueModel copyWith({
    int? id,
    int? line,
    String? hotkey,
    PlayMode? mode,
    String? soundId,
    DateTime? createdAt,
    int? startMs,
    int? endMs,
    bool clearStart = false,
    bool clearEnd = false,
  }) {
    return SoundCueModel(
      id: id ?? this.id,
      line: line ?? this.line,
      hotkey: hotkey ?? this.hotkey,
      mode: mode ?? this.mode,
      soundId: soundId ?? this.soundId,
      createdAt: createdAt ?? this.createdAt,
      startMs: clearStart ? null : (startMs ?? this.startMs),
      endMs: clearEnd ? null : (endMs ?? this.endMs),
    );
  }
}
