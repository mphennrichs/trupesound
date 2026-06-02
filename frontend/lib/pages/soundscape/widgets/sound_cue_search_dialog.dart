import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';

class SoundCueSearchDialog extends HookConsumerWidget {
  final int playId;
  final int actNumber;
  final int targetLineNumber;

  const SoundCueSearchDialog({
    super.key,
    required this.playId,
    required this.actNumber,
    required this.targetLineNumber,
  });

  Widget _buildSearchContainer() {
    return Text(
      'search here',
      style: TextStyle(
        color: AppThemes.colors.textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildButton(AppLocalizations l10n, VoidCallback onSave) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onSave,
          style: AppThemes.buttons.secondaryButtonStyle,
          child: Text(
            l10n.save,
            style: TextStyle(fontSize: AppThemes.texts.smallFontSize),
          ),
        ),
      ],
    );
  }

  Widget _buildSoundCue(
    BuildContext context,
    SoundModel sound,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppThemes.borders.defaultBorderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppThemes.colors.primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: AppThemes.borders.defaultBorderRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sound.name, style: const TextStyle(color: Colors.white)),
                  Text(
                    sound.category.getText(context),
                    style: TextStyle(
                      color: AppThemes.colors.textColor,
                      fontSize: AppThemes.texts.verySmallFontSize,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppThemes.colors.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsAsync = ref.watch(filteredSoundsProvider);
    final l10n = AppLocalizations.of(context)!;
    final selectedSoundId = useState<int?>(null);
    final selectedSound = useState<SoundModel?>(null);

    void onSave() {
      if (selectedSound.value == null) return;

      final playsAsync = ref.read(playsProvider);
      final plays = playsAsync.value ?? [];
      final playIndex = plays.indexWhere((p) => p.id == playId);
      if (playIndex == -1) return;

      final play = plays[playIndex];
      final updatedActs = play.acts.map((act) {
        if (act.number != actNumber) return act;

        final updatedScript = act.script.map((line) {
          if (line.lineNumber >= targetLineNumber) {
            return line.copyWith(lineNumber: line.lineNumber + 1);
          }
          return line;
        }).toList();

        final updatedCues = act.cues.map((cue) {
          if (cue.line >= targetLineNumber) {
            return cue.copyWith(line: cue.line + 1);
          }
          return cue;
        }).toList();

        // Create the new cue and add it to the list
        final newCue = SoundCueModel(
          id: DateTime.now().millisecondsSinceEpoch,
          line: targetLineNumber,
          hotkey: '',
          mode: PlayMode.once,
          soundId: selectedSound.value!.id.toString(),
          createdAt: DateTime.now(),
        );

        // We use a new list to ensure the state update is detected
        final finalCues = [...updatedCues, newCue];

        return act.copyWith(script: updatedScript, cues: finalCues);
      }).toList();

      final updatedPlay = play.copyWith(acts: updatedActs);
      final newList = [...plays];
      newList[playIndex] = updatedPlay;
      ref.read(playsProvider.notifier).updatePlay(updatedPlay);
      Navigator.of(context).pop();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(AppThemes.spacings.singleValue),
        decoration: BoxDecoration(
          color: AppThemes.colors.cardColor,
          borderRadius: AppThemes.borders.defaultBorderRadius,
          border: Border.all(color: AppThemes.colors.borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchContainer(),
            Divider(color: AppThemes.colors.borderColor),
            soundsAsync.when(
              data: (sounds) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sounds.map((sound) {
                  return _buildSoundCue(
                    context,
                    sound,
                    selectedSoundId.value == sound.id,
                    () {
                      selectedSoundId.value = sound.id;
                      selectedSound.value = sound;
                    },
                  );
                }).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text(
                'Error: $err',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            Divider(color: AppThemes.colors.borderColor),
            _buildButton(l10n, onSave),
          ],
        ),
      ),
    );
  }
}
