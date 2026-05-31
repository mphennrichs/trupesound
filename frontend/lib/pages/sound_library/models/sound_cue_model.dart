enum PlayMode { once, repeat }

class SoundCueModel {
  final String id;
  final String hotkey;
  final PlayMode mode;
  final String soundId;
  final DateTime createdAt;

  SoundCueModel({
    required this.id,
    required this.hotkey,
    required this.mode,
    required this.soundId,
    required this.createdAt,
  });
}
