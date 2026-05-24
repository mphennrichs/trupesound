import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/models/play.dart';
import 'package:trupe_sound/pages/plays/service/play_service.dart';

part 'plays_provider.g.dart';

@riverpod
class Plays extends _$Plays {
  @override
  Future<List<Play>> build() async {
    return ref.read(playServiceProvider).list();
  }

  /// Adds a new play and updates the local state manually for a smooth UX
  Future<Play?> addPlay(Play play) async {
    final result = await ref.read(playServiceProvider).save(play);

    if (result != null && state.hasValue) {
      final previousData = state.value!;
      state = AsyncData([...previousData, result]);
    }

    return result;
  }

  /// Updates an existing play in the local list
  Future<void> updatePlay(Play play) async {
    final result = await ref.read(playServiceProvider).update(play);

    if (result != null && state.hasValue) {
      state = AsyncData(
        state.value!.map((p) => p.id == result.id ? result : p).toList(),
      );
    }
  }

  /// Removes a play from the local list
  Future<void> deletePlay(int id) async {
    final success = await ref.read(playServiceProvider).delete(id);

    if (success && state.hasValue) {
      state = AsyncData(state.value!.where((p) => p.id != id).toList());
    }
  }

  /// Forces a full refresh with a loading state
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(playServiceProvider).list());
  }
}
