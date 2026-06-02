import 'package:flutter/material.dart';
import 'package:numerus/numerus.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/models/act.dart' as models;
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/soundscape/widgets/script_line.dart';
import 'package:trupe_sound/pages/soundscape/widgets/inline_add_cue.dart';

class ActTabs extends StatelessWidget {
  final Play play;

  const ActTabs({super.key, required this.play});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: play.acts.length,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: AppThemes.colors.borderColor),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
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
                children: play.acts
                    .map((act) => _buildActContent(context, act))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActContent(BuildContext context, models.ActModel act) {
    final l10n = AppLocalizations.of(context)!;

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
              itemCount: act.script.length + 1,
              itemBuilder: (context, index) {
                if (index == act.script.length) {
                  return const InlineAddCue();
                }
                final line = act.script[index];
                return ScriptLine(lineNumber: line.lineNumber, text: line.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
