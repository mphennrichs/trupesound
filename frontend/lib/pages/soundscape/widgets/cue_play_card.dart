import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/providers/audio_player_provider.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/soundscape/provider/sound_playback_provider.dart';
import 'package:trupe_sound/pages/soundscape/widgets/active_tag.dart';
import 'package:trupe_sound/pages/soundscape/widgets/hotkey_capture_dialog.dart';

class CuePlayCard extends ConsumerWidget {
  final SoundCueModel cue;
  final int playId;
  final int actNumber;

  const CuePlayCard({
    super.key,
    required this.cue,
    required this.playId,
    required this.actNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Optimization: Only listen to the sound data relevant to this cue
    final soundsAsync = ref.watch(filteredSoundsProvider);
    final sound = soundsAsync.maybeWhen(
      data: (sounds) =>
          sounds.where((s) => s.id.toString() == cue.soundId).firstOrNull,
      orElse: () => null,
    );

    final playbackState = ref.watch(soundPlaybackProvider);
    final isPlaying = playbackState.playingIds.contains(cue.id);
    final isRepeat = cue.mode == PlayMode.repeat;

    final activeColor = isPlaying
        ? AppThemes.colors.primaryColor
        : AppThemes.colors.cardColor;

    final audioState = ref.watch(audioPlayerProvider);
    double progress = 0.0;
    if (isPlaying && sound != null) {
      final startMs = cue.startMs ?? 0;
      final endMs = cue.endMs ?? sound.duration.inMilliseconds;
      final totalMs = (endMs - startMs).clamp(1, double.infinity);
      final positionMs = audioState.position.inMilliseconds;
      // position resets on loop, so mod by totalMs to keep bar cycling
      final relativeMs = isRepeat ? positionMs % totalMs : positionMs - startMs;
      progress = (relativeMs / totalMs).clamp(0.0, 1.0);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemes.colors.backgroundColor,
        border: Border.all(color: AppThemes.colors.borderColor),
        borderRadius: AppThemes.borders.defaultBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
        children: [
          // Column 1: Hotkey Square
          InkWell(
            onTap: () => _showHotkeyDialog(context, ref),
            borderRadius: AppThemes.borders.defaultBorderRadius,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: AppThemes.borders.defaultBorderRadius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isPlaying
                      ? Icon(
                          Icons.stop_circle_outlined,
                          color: Colors.white,
                          size: AppThemes.texts.normalFontSize,
                        )
                      : Text(
                          l10n.hotkey.toUpperCase(),
                          style: TextStyle(
                            color: AppThemes.colors.textColor,
                            fontSize: AppThemes.texts.verySmallFontSize,
                          ),
                        ),
                  Text(
                    cue.hotkey.isEmpty ? '?' : cue.hotkey.toUpperCase(),
                    style: TextStyle(
                      color: isPlaying ? Colors.white : AppThemes.colors.textColor,
                      fontSize: AppThemes.texts.normalFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppThemes.spacings.singleSpace,
          // Column 2: Sound Name and Type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: sound != null
                          ? Text(
                              sound.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppThemes.texts.normalFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          : Shimmer.fromColors(
                              baseColor: AppThemes.colors.borderColor,
                              highlightColor: AppThemes.colors.cardColor,
                              child: Container(
                                width: 120,
                                height: AppThemes.texts.normalFontSize,
                                decoration: BoxDecoration(
                                  color: AppThemes.colors.cardColor,
                                ),
                              ),
                            ),
                    ),
                    if (isPlaying) ...[
                      SizedBox(width: AppThemes.spacings.singleValue / 2),
                      const ActiveTag(),
                    ],
                  ],
                ),
                if (sound == null) AppThemes.spacings.halfSpace,
                if (sound != null)
                  Row(
                    children: [
                      Text(
                        sound.category.getText(context).toUpperCase(),
                        style: TextStyle(
                          color: AppThemes.colors.hintTextColor,
                          fontSize: AppThemes.texts.smallFontSize,
                        ),
                      ),
                      SizedBox(width: AppThemes.spacings.singleValue / 2),
                      Text(
                        '· ${_formatCueDuration(sound.duration.inMilliseconds)}',
                        style: TextStyle(
                          color: AppThemes.colors.hintTextColor,
                          fontSize: AppThemes.texts.smallFontSize,
                        ),
                      ),
                    ],
                  )
                else
                  Shimmer.fromColors(
                    baseColor: AppThemes.colors.borderColor,
                    highlightColor: AppThemes.colors.cardColor,
                    child: Container(
                      width: 80,
                      height: AppThemes.texts.smallFontSize,
                      decoration: BoxDecoration(
                        color: AppThemes.colors.cardColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppThemes.spacings.singleSpace,
          // Column 3: Repeat Switch
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.repeat.toUpperCase(),
                style: TextStyle(
                  color: AppThemes.colors.textColor,
                  fontSize: AppThemes.texts.verySmallFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isRepeat,
                    activeThumbColor: AppThemes.colors.primaryColor,
                    inactiveTrackColor: AppThemes.colors.cardColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {
                      ref
                          .read(playsProvider.notifier)
                          .updateCueMode(
                            playId: playId,
                            actNumber: actNumber,
                            cueId: cue.id,
                            mode: value ? PlayMode.repeat : PlayMode.once,
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
          AppThemes.spacings.singleSpace,
          // Column 4: Play/Stop Button
          IconButton(
            icon: Icon(
              isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
              color: AppThemes.colors.primaryColor,
              size: AppThemes.texts.h1FontSize * 1.8,
            ),
            onPressed: () {
              ref.read(soundPlaybackProvider.notifier).togglePlayback(
                cue.id,
                cue.soundId,
                startMs: cue.startMs,
                endMs: cue.endMs,
                loop: isRepeat,
              );
            },
          ),
        ],
      ),
          if (isPlaying) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: AppThemes.borders.defaultBorderRadius,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: AppThemes.colors.borderColor,
                valueColor: AlwaysStoppedAnimation(AppThemes.colors.primaryColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCueDuration(int soundDurationMs) {
    final start = cue.startMs ?? 0;
    final end = cue.endMs ?? soundDurationMs;
    final ms = (end - start).clamp(0, soundDurationMs);
    final d = Duration(milliseconds: ms);
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showHotkeyDialog(BuildContext context, WidgetRef ref) {
    final playsState = ref.read(playsProvider);
    final plays = playsState.when(data: (v) => v, loading: () => const <Play>[], error: (e, s) => const <Play>[]);
    final play = plays.where((p) => p.id == playId).firstOrNull;
    final usedHotkeys = play == null
        ? <String>{}
        : {
            for (final act in play.acts)
              for (final c in act.cues)
                if (c.id != cue.id && c.hotkey.isNotEmpty)
                  c.hotkey.toLowerCase(),
          };

    showDialog(
      context: context,
      builder: (context) => HotkeyCaptureDialog(
        usedHotkeys: usedHotkeys,
        onHotkeyCaptured: (key) {
          ref
              .read(playsProvider.notifier)
              .updateCueHotkey(
                playId: playId,
                actNumber: actNumber,
                cueId: cue.id,
                hotkey: key,
              );
        },
      ),
    );
  }
}
