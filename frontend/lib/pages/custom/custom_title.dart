import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final String description;

  const CustomTitle({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: AppThemes.texts.h1FontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          description,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: AppThemes.texts.normalFontSize,
            color: AppThemes.colors.textColor,
          ),
        ),
      ],
    );
  }
}
