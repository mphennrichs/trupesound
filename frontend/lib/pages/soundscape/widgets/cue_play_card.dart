import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/soundscape/widgets/sound_playback_provider.dart';

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

    Container activeTag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: AppThemes.borders.defaultBorderRadius,
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),

      child: Text(
        l10n.active.toUpperCase(),
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: AppThemes.texts.verySmallFontSize,
        ),
      ),
    );

    // Optimization: Only listen to the sound data relevant to this cue
    final soundsAsync = ref.watch(filteredSoundsProvider);
    final sound = soundsAsync.maybeWhen(
      data: (sounds) =>
          sounds.where((s) => s.id.toString() == cue.soundId).firstOrNull,
      orElse: () => null,
    );

    final soundName = sound?.name ?? 'Unknown Sound';
    final soundCategory = sound?.category.getText(context) ?? 'Unknown Type';

    final playbackState = ref.watch(soundPlaybackProvider);
    final isPlaying = playbackState.playingIds.contains(cue.id);
    final isRepeat = playbackState.repeatSettings[cue.id] ?? true;

    final activeColor = isPlaying
        ? AppThemes.colors.primaryColor
        : AppThemes.colors.cardColor;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemes.colors.backgroundColor,
        border: Border.all(color: AppThemes.colors.borderColor),
        borderRadius: AppThemes.borders.defaultBorderRadius,
      ),
      child: Row(
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
                  Text(
                    l10n.hotkey.toUpperCase(),
                    style: TextStyle(
                      color: AppThemes.colors.textColor,
                      fontSize: AppThemes.texts.verySmallFontSize,
                    ),
                  ),
                  Text(
                    cue.hotkey.isEmpty ? '?' : cue.hotkey.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      soundName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppThemes.texts.normalFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isPlaying) activeTag,
                  ],
                ),
                Text(
                  soundCategory.toUpperCase(),
                  style: TextStyle(
                    color: AppThemes.colors.hintTextColor,
                    fontSize: AppThemes.texts.smallFontSize,
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
                          .read(soundPlaybackProvider.notifier)
                          .setRepeat(cue.id, value);
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
              isPlaying ? Icons.stop_circle : Icons.play_circle_fill_outlined,
              color: AppThemes.colors.primaryColor,
              size: AppThemes.texts.h1FontSize * 1.8,
            ),
            onPressed: () {
              ref.read(soundPlaybackProvider.notifier).togglePlayback(cue.id);
            },
          ),
        ],
      ),
    );
  }

  void _showHotkeyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _HotkeyCaptureDialog(
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

class _HotkeyCaptureDialog extends StatefulWidget {
  final ValueChanged<String> onHotkeyCaptured;

  const _HotkeyCaptureDialog({required this.onHotkeyCaptured});

  @override
  State<_HotkeyCaptureDialog> createState() => _HotkeyCaptureDialogState();
}

class _HotkeyCaptureDialogState extends State<_HotkeyCaptureDialog> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final label = event.logicalKey.keyLabel;
          if (label.length == 1) {
            widget.onHotkeyCaptured(label);
            Navigator.of(context).pop();
          }
        }
      },
      child: AlertDialog(
        backgroundColor: AppThemes.colors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppThemes.borders.defaultBorderRadius,
          side: BorderSide(color: AppThemes.colors.borderColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard,
              color: AppThemes.colors.primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Press a key to set hotkey',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
