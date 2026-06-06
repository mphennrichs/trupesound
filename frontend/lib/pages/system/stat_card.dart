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
    return Container(
      padding: EdgeInsets.all(AppThemes.spacings.singleValue),
      decoration: BoxDecoration(
        color: AppThemes.colors.cardColor,
        borderRadius: AppThemes.borders.defaultBorderRadius,
        border: Border.all(color: AppThemes.colors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppThemes.colors.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppThemes.colors.primaryColor, size: 22),
          ),
          SizedBox(width: AppThemes.spacings.singleValue),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppThemes.texts.h1FontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppThemes.colors.hintTextColor,
                  fontSize: AppThemes.texts.smallFontSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
