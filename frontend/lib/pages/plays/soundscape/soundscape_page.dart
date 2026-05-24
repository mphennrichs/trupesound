import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class Soundscape extends StatelessWidget {
  final int playId;

  const Soundscape({super.key, required this.playId});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppThemes.colors.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: AppThemes.spacings.doubleValue,
          horizontal: AppThemes.spacings.doubleValue,
        ),
        child: Center(
          // O Center garante alinhamento vertical e horizontal [8]
          child: Text(
            'Soundscape',
            style: TextStyle(fontSize: 24, color: AppThemes.colors.textColor),
          ),
        ),
      ),
    );
  }
}
