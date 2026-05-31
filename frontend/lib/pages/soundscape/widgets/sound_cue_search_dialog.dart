import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class SoundCueSearchDialog extends StatelessWidget {
  const SoundCueSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(AppThemes.spacings.singleValue),
        decoration: BoxDecoration(
          color: AppThemes.colors.cardColor,
          borderRadius: AppThemes.borders.defaultBorderRadius,
          border: Border.all(color: AppThemes.colors.borderColor),
        ),
        child: Text(
          'Sound cue search dialog',
          style: TextStyle(color: AppThemes.colors.textColor),
        ),
      ),
    );
  }
}
