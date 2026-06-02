import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/pages/soundscape/widgets/inline_add_cue.dart';

class ScriptLine extends StatelessWidget {
  final int playId;
  final int actNumber;
  final int lineNumber;
  final String text;

  const ScriptLine({
    super.key,
    required this.playId,
    required this.actNumber,
    required this.lineNumber,
    required this.text,
  });

  ScriptLine copyWith({
    int? playId,
    int? actNumber,
    int? lineNumber,
    String? text,
  }) {
    return ScriptLine(
      playId: playId ?? this.playId,
      actNumber: actNumber ?? this.actNumber,
      lineNumber: lineNumber ?? this.lineNumber,
      text: text ?? this.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InlineAddCue(
          playId: playId,
          actNumber: actNumber,
          targetLineNumber: lineNumber,
        ),
        Padding(
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
        ),
      ],
    );
  }
}
