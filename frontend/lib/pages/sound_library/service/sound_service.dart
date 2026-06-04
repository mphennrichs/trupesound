import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/service/sound_repository.dart';

part 'sound_service.g.dart';

@Riverpod()
SoundService soundService(Ref ref) => SoundService();

class SoundService {
  final SoundRepository _repo = SoundRepository();

  Future<List<SoundModel>> list() async {
    await Future.delayed(const Duration(seconds: 1));
    return _repo.list();
  }

  Future<void> add(SoundModel sound) async => _repo.add(sound);

  Future<void> delete(int id) async => _repo.delete(id);
}
