import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';

class SoundRepository {
  static final SoundRepository _singleton = SoundRepository._internal();

  factory SoundRepository() => _singleton;

  SoundRepository._internal();

  final List<SoundModel> _sounds = [
    SoundModel(
      id: 1,
      name: 'Ambient Forest',
      category: SoundCategory.effect,
      duration: const Duration(minutes: 2),
      url: '',
      createdAt: DateTime.now(),
    ),
    SoundModel(
      id: 2,
      name: 'Crowd Cheering',
      category: SoundCategory.ambient,
      duration: const Duration(seconds: 45),
      url: '',
      createdAt: DateTime.now(),
    ),
    SoundModel(
      id: 3,
      name: 'Deslizes',
      category: SoundCategory.song,
      duration: const Duration(minutes: 5, seconds: 12),
      url: '',
      createdAt: DateTime.now(),
    ),
  ];

  List<SoundModel> list() => List.unmodifiable(_sounds);

  void add(SoundModel sound) => _sounds.add(sound);

  void delete(int id) => _sounds.removeWhere((s) => s.id == id);
}
