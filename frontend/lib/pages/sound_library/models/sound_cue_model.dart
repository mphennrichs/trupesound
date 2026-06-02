enum PlayMode { once, repeat }

class SoundCueModel {
  final String id;
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

  //copywith
  SoundCueModel copyWith({
    String? id,
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
