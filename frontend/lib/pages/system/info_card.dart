import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final bool isSelectable;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.isSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppThemes.colors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppThemes.borders.defaultBorderRadius,
        side: BorderSide(color: AppThemes.colors.borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppThemes.spacings.singleValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: AppThemes.colors.textColor, fontSize: 12),
            ),
            if (isSelectable)
              SelectableText(
                value,
                style: TextStyle(
                  color: AppThemes.colors.textColor,
                  fontSize: AppThemes.texts.normalFontSize,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                value,
                style: TextStyle(
                  color: AppThemes.colors.textColor,
                  fontSize: AppThemes.texts.normalFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              subtitle,
              style: TextStyle(
                color: AppThemes.colors.textColor,
                fontSize: AppThemes.texts.smallFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
