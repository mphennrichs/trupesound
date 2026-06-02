import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';

class ScriptCueItem extends ConsumerWidget {
  final SoundCueModel cue;
  final VoidCallback? onDelete;

  const ScriptCueItem({super.key, required this.cue, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final soundsAsync = ref.watch(filteredSoundsProvider);
    final soundName = soundsAsync.maybeWhen(
      data: (sounds) =>
          sounds
              .where((s) => s.id.toString() == cue.soundId)
              .firstOrNull
              ?.name ??
          'Unknown Sound',
      orElse: () => '...',
    );

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
          Icon(
            Icons.play_circle_fill_outlined,
            color: AppThemes.colors.primaryColor,
            size: AppThemes.texts.h1FontSize * 1.5,
          ),
          const SizedBox(width: 12),
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
