import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/soundscape/widgets/cue_play_card.dart';
import 'package:trupe_sound/pages/soundscape/widgets/sound_playback_provider.dart';

class SoundCueList extends ConsumerWidget {
  final Play play;

  const SoundCueList({super.key, required this.play});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = DefaultTabController.of(context);

    return Container(
      decoration: BoxDecoration(color: AppThemes.colors.backgroundColor),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final currentActIndex = controller.index;
          if (currentActIndex >= play.acts.length) {
            return const SizedBox.shrink();
          }

          final act = play.acts[currentActIndex];

          // Sort cues by their line number position
          final sortedCues = [...act.cues];
          sortedCues.sort((a, b) => a.line.compareTo(b.line));

          return Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent) {
                final keyLabel = event.logicalKey.keyLabel.toLowerCase();
                for (final cue in act.cues) {
                  if (cue.hotkey.toLowerCase() == keyLabel &&
                      keyLabel.isNotEmpty) {
                    ref
                        .read(soundPlaybackProvider.notifier)
                        .togglePlayback(cue.id);
                    return KeyEventResult.handled;
                  }
                }
              }
              return KeyEventResult.ignored;
            },
            child: Padding(
              padding: EdgeInsets.all(AppThemes.spacings.doubleValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.soundCues, // Using soundLibrary as title for the cues section
                    style: TextStyle(
                      fontSize: AppThemes.texts.h1FontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppThemes.spacings.doubleSpace,
                  Expanded(
                    child: sortedCues.isEmpty
                        ? AppThemes.spacings.singleSpace
                        : ListView.separated(
                            itemCount: sortedCues.length,
                            separatorBuilder: (context, index) =>
                                AppThemes.spacings.singleSpace,
                            itemBuilder: (context, index) {
                              return CuePlayCard(
                                cue: sortedCues[index],
                                playId: play.id,
                                actNumber: act.number,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
