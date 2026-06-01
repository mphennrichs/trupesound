import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class SoundCueSearchDialog extends StatelessWidget {
  const SoundCueSearchDialog({super.key});

  Widget _buildSearchContainer() {
    return Text(
      'search here',
      style: TextStyle(
        color: AppThemes.colors.textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(AppThemes.spacings.singleValue),
        decoration: BoxDecoration(
          color: AppThemes.colors.cardColor,
          borderRadius: AppThemes.borders.defaultBorderRadius,
          border: Border.all(color: AppThemes.colors.borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchContainer(),
            Divider(color: AppThemes.colors.borderColor),
            AppThemes.spacings.singleSpace,
            // Placeholder for the list of available sounds
            ...['Wind.wav', 'Rain_Ambient.mp3', 'Thunder_01.wav'].map(
              (sound) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  sound,
                  style: TextStyle(color: AppThemes.colors.textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
