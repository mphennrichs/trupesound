import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/service/sound_service.dart';

part 'sound_provider.g.dart';

@riverpod
class Sounds extends _$Sounds {
  @override
  FutureOr<List<SoundModel>> build() async {
    return ref.read(soundServiceProvider).list();
  }

  Future<void> deleteSound(int id) async {
    if (!state.hasValue) return;
    await ref.read(soundServiceProvider).delete(id);
    state = AsyncData(state.value!.where((s) => s.id != id).toList());
  }

  Future<void> addSound(SoundModel sound) async {
    if (!state.hasValue) return;
    await ref.read(soundServiceProvider).add(sound);
    state = AsyncData([...state.value!, sound]);
  }
}

@riverpod
class SoundCategoryFilter extends _$SoundCategoryFilter {
  @override
  SoundCategory build() => SoundCategory.all;

  void set(SoundCategory category) => state = category;
}

@riverpod
AsyncValue<List<SoundModel>> filteredSounds(Ref ref) {
  final category = ref.watch(soundCategoryFilterProvider);
  final soundsAsync = ref.watch(soundsProvider);

  return soundsAsync.whenData((sounds) {
    return sounds.where((sound) {
      final matchesCategory =
          category == SoundCategory.all || sound.category == category;
      final isNotArchived = !sound.archived;
      return matchesCategory && isNotArchived;
    }).toList();
  });
}

@riverpod
List<SoundModel> allSounds(Ref ref) {
  return ref.watch(soundsProvider).value ?? [];
}

@riverpod
Map<SoundCategory, int> soundCountsByCategory(Ref ref) {
  final sounds = ref.watch(allSoundsProvider);
  final counts = <SoundCategory, int>{};

  for (final sound in sounds) {
    counts[sound.category] = (counts[sound.category] ?? 0) + 1;
  }

  return counts;
}
