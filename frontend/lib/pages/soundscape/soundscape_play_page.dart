import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

class SoundscapePage extends StatelessWidget {
  final int playId;

  const SoundscapePage({super.key, required this.playId});

  ElevatedButton _getBackToHomePageButton(BuildContext context) {
    return ElevatedButton(
      style: AppThemes.buttons.primaryButtonStyle,
      onPressed: () => context.goNamed(NavigationPage.plays.name),
      child: Text(AppLocalizations.of(context)!.back),
    );
  }

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
          child: Column(
            children: [
              Text(
                'Soundscape',
                style: TextStyle(
                  fontSize: 24,
                  color: AppThemes.colors.textColor,
                ),
              ),

              _getBackToHomePageButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
