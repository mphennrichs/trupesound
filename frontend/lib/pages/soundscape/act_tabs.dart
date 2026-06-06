import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numerus/numerus.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/models/act.dart' as models;
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';
import 'package:trupe_sound/pages/soundscape/widgets/script_cue_item.dart';
import 'package:trupe_sound/pages/soundscape/widgets/script_line.dart';
import 'package:trupe_sound/pages/soundscape/widgets/inline_add_cue.dart';

class ActTabs extends ConsumerWidget {
  final Play play;

  const ActTabs({super.key, required this.play});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = DefaultTabController.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: AppThemes.colors.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppThemes.colors.primaryColor,
            dividerColor: AppThemes.colors.borderColor,
            labelColor: Colors.white,
            unselectedLabelColor: AppThemes.colors.textColor,
            tabs: play.acts
                .map(
                  (act) => Tab(
                    text: '${l10n.act} ${act.number.toRomanNumeralString()}',
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: play.acts
                  .map((act) => _buildActContent(context, ref, act))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActContent(
    BuildContext context,
    WidgetRef ref,
    models.ActModel act,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // Combine script lines and cues into a single list sorted by line
    final List<dynamic> items = [...act.script, ...act.cues];
    items.sort((a, b) {
      final aLine = a is models.ScriptLine
          ? a.line
          : (a as SoundCueModel).line;
      final bLine = b is models.ScriptLine
          ? b.line
          : (b as SoundCueModel).line;
      return aLine.compareTo(bLine);
    });

    return Padding(
      padding: EdgeInsets.all(AppThemes.spacings.doubleValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.act} ${act.number.toRomanNumeralString()}',
            style: TextStyle(
              fontSize: AppThemes.texts.h1FontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppThemes.spacings.doubleSpace,
          Expanded(
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                final targetLine = index < items.length
                    ? (items[index] is models.ScriptLine
                          ? (items[index] as models.ScriptLine).line
                          : (items[index] as SoundCueModel).line)
                    : (items.isEmpty
                          ? 1
                          : (items.last is models.ScriptLine
                                    ? (items.last as models.ScriptLine)
                                          .line
                                    : (items.last as SoundCueModel).line) +
                                1);

                if (index == items.length) {
                  return InlineAddCue(
                    playId: play.id,
                    actNumber: act.number,
                    targetLineNumber: targetLine,
                  );
                }

                final item = items[index];
                if (item is models.ScriptLine) {
                  return ScriptLine(
                    playId: play.id,
                    actNumber: act.number,
                    line: item.line,
                    text: item.text,
                  );
                } else {
                  final cueItem = item as SoundCueModel;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InlineAddCue(
                        playId: play.id,
                        actNumber: act.number,
                        targetLineNumber: targetLine,
                      ),
                      ScriptCueItem(
                        cue: cueItem,
                        onDelete: () {
                          ref
                              .read(playsProvider.notifier)
                              .removeCue(
                                playId: play.id,
                                actNumber: act.number,
                                cue: cueItem,
                              );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
