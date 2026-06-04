import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppThemes.colors.cardColor,
      child: Padding(
        padding: EdgeInsets.all(AppThemes.spacings.singleValue),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppThemes.colors.textColor,
              size: AppThemes.texts.h1FontSize * 1.5,
            ),
            AppThemes.spacings.singleSpace,
            Text(
              value,
              style: TextStyle(
                color: AppThemes.colors.textColor,
                fontSize: AppThemes.texts.h1FontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppThemes.colors.textColor,
                fontSize: AppThemes.texts.normalFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
