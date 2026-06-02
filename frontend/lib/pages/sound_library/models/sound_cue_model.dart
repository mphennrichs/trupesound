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
}
