import 'package:flutter/material.dart';
import 'package:numerus/numerus.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/models/act.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';

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

  Widget _buildActContent(BuildContext context, Act act) {
    final l10n = AppLocalizations.of(context)!;
    // Split script text into lines for numbering
    final lines = act.script.split('\n');

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
              itemCount: lines.length,
              itemBuilder: (context, index) {
                return _buildScriptLine(index + 1, lines[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScriptLine(int lineNumber, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              lineNumber.toString(),
              style: TextStyle(
                color: AppThemes.colors.hintTextColor,
                fontSize: AppThemes.texts.smallFontSize,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppThemes.texts.normalFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
