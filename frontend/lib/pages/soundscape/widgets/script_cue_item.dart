import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/soundscape/provider/sound_playback_provider.dart';
import 'package:trupe_sound/pages/soundscape/widgets/cue_trim_dialog.dart';

class ScriptCueItem extends ConsumerWidget {
  final SoundCueModel cue;
  final int playId;
  final int actNumber;
  final VoidCallback? onDelete;

  const ScriptCueItem({
    super.key,
    required this.cue,
    required this.playId,
    required this.actNumber,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final soundsAsync = ref.watch(filteredSoundsProvider);
    final sound = soundsAsync.maybeWhen(
      data: (sounds) => sounds.where((s) => s.id.toString() == cue.soundId).firstOrNull,
      orElse: () => null,
    );
    final soundName = sound?.name ?? '...';

    final playbackState = ref.watch(soundPlaybackProvider);
    final isPlaying = playbackState.playingIds.contains(cue.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemes.colors.cardColor,
        borderRadius: AppThemes.borders.defaultBorderRadius,
        border: Border.all(
          color: AppThemes.colors.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
              color: AppThemes.colors.primaryColor,
              size: AppThemes.texts.h1FontSize * 1.5,
            ),
            onPressed: sound == null
                ? null
                : () => ref.read(soundPlaybackProvider.notifier).togglePlayback(
                      cue.id,
                      cue.soundId,
                      startMs: cue.startMs,
                      endMs: cue.endMs,
                      loop: cue.mode == PlayMode.repeat,
                    ),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${l10n.singleCue} ${cue.line}: $soundName',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: AppThemes.texts.normalFontSize,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              color: AppThemes.colors.hintTextColor,
              size: AppThemes.texts.h1FontSize,
            ),
            tooltip: l10n.edit,
            onPressed: sound == null
                ? null
                : () => CueTrimDialog.show(
                      context,
                      cue: cue,
                      sound: sound,
                      playId: playId,
                      actNumber: actNumber,
                    ),
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: AppThemes.texts.h1FontSize,
            ),
            tooltip: l10n.delete,
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
