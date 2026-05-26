import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';

part 'sound_provider.g.dart';

@riverpod
class SoundRepository extends _$SoundRepository {
  @override
  FutureOr<List<SoundModel>> build() async {
    // This acts as your "Source of Truth"
    // Simulating a fetch from a database or API
    await Future.delayed(const Duration(seconds: 1));
    return [
      SoundModel(
        id: '1',
        name: 'Ambient Forest',
        category: SoundCategory.effect,
        duration: const Duration(minutes: 2),
        url: '',
        createdAt: DateTime.now(),
      ),
      SoundModel(
        id: '2',
        name: 'Crowd Cheering',
        category: SoundCategory.ambient,
        duration: const Duration(seconds: 45),
        url: '',
        createdAt: DateTime.now(),
      ),
      SoundModel(
        id: '3',
        name: 'Deslizes',
        category: SoundCategory.song,
        duration: const Duration(minutes: 5, seconds: 12),
        url: '',
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<void> deleteSound(String id) async {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.where((a) => a.id != id).toList());
  }
}

@riverpod
AsyncValue<List<SoundModel>> filteredSounds(Ref ref) {
  final soundsAsync = ref.watch(soundRepositoryProvider);
  return soundsAsync;
}
