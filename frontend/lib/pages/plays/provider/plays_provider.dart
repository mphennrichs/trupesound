import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';
import 'package:trupe_sound/pages/plays/service/play_service.dart';
import 'package:trupe_sound/pages/plays/models/act.dart' as models;

part 'plays_provider.g.dart';

@riverpod
class Plays extends _$Plays {
  @override
  Future<List<Play>> build() async {
    return ref.read(playServiceProvider).list();
  }

  Future<Play?> addPlay(Play play) async {
    final result = await ref.read(playServiceProvider).save(play);

    if (result != null && state.hasValue) {
      final previousData = state.value!;
      state = AsyncData([...previousData, result]);
    }

    return result;
  }

  Future<void> updatePlay(Play play) async {
    final result = await ref.read(playServiceProvider).update(play);

    if (result != null && state.hasValue) {
      state = AsyncData(
        state.value!.map((p) => p.id == result.id ? result : p).toList(),
      );
    }
  }

  Future<void> removeCue({
    required int playId,
    required int actNumber,
    required SoundCueModel cue,
  }) async {
    if (!state.hasValue) return;

    final play = state.value!.firstWhere((p) => p.id == playId);
    final updatedPlay = play.copyWith(
      acts: play.acts.map((act) {
        if (act.number != actNumber) return act;

        // 1. Filter out the specific cue to be removed
        final remainingCues = act.cues.where((c) => c.id != cue.id).toList();

        // 2. Combine all remaining items to establish a new sequence
        final allItems = [...act.script, ...remainingCues];

        // 3. Sort by current line number to maintain relative order
        allItems.sort((a, b) {
          final aPos = a is models.ScriptLine
              ? a.line
              : (a as SoundCueModel).line;
          final bPos = b is models.ScriptLine
              ? b.line
              : (b as SoundCueModel).line;
          if (aPos != bPos) return aPos.compareTo(bPos);
          // Tie-breaker: ScriptLines before Cues if they share the same index
          return (a is models.ScriptLine) ? -1 : 1;
        });

        // 4. Re-assign sequential line numbers (1, 2, 3...) to fill gaps
        final updatedScript = <models.ScriptLine>[];
        final updatedCues = <SoundCueModel>[];

        for (int i = 0; i < allItems.length; i++) {
          final item = allItems[i];
          final newIndex = i + 1;
          if (item is models.ScriptLine) {
            updatedScript.add(item.copyWith(line: newIndex));
          } else if (item is SoundCueModel) {
            updatedCues.add(item.copyWith(line: newIndex));
          }
        }

        return act.copyWith(script: updatedScript, cues: updatedCues);
      }).toList(),
    );

    await updatePlay(updatedPlay);
  }

  Future<void> deletePlay(int id) async {
    final success = await ref.read(playServiceProvider).delete(id);

    if (success && state.hasValue) {
      state = AsyncData(state.value!.where((p) => p.id != id).toList());
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(playServiceProvider).list());
  }

  Future<void> updateCueHotkey({
    required int playId,
    required int actNumber,
    required int cueId,
    required String hotkey,
  }) async {
    if (!state.hasValue) return;

    final plays = state.value!;
    final playIndex = plays.indexWhere((p) => p.id == playId);
    if (playIndex == -1) return;

    final play = plays[playIndex];
    final updatedPlay = play.copyWith(
      acts: play.acts.map((act) {
        if (act.number != actNumber) return act;
        return act.copyWith(
          cues: act.cues.map((cue) {
            if (cue.id != cueId) return cue;
            return cue.copyWith(hotkey: hotkey);
          }).toList(),
        );
      }).toList(),
    );

    await updatePlay(updatedPlay);
  }

  Future<void> updateCueMode({
    required int playId,
    required int actNumber,
    required int cueId,
    required PlayMode mode,
  }) async {
    if (!state.hasValue) return;

    final plays = state.value!;
    final playIndex = plays.indexWhere((p) => p.id == playId);
    if (playIndex == -1) return;

    final play = plays[playIndex];
    final updatedPlay = play.copyWith(
      acts: play.acts.map((act) {
        if (act.number != actNumber) return act;
        return act.copyWith(
          cues: act.cues.map((cue) {
            if (cue.id != cueId) return cue;
            return cue.copyWith(mode: mode);
          }).toList(),
        );
      }).toList(),
    );

    await updatePlay(updatedPlay);
  }

}
