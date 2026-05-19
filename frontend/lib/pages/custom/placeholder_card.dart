import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/dashed_container.dart';

class PlaceholderCard extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;

  const PlaceholderCard({
    super.key,
    required this.onTap,
    this.width = 200,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DashedContainer(
      onTap: onTap,
      width: width,
      height: height,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle,
            size: 80,
            color: AppThemes.colors.primaryColor.withValues(alpha: 0.7),
          ),
          AppThemes.spacings.doubleSpace,
          Text(
            l10n.createNewPlay,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppThemes.texts.h2FontSize,
              fontWeight: FontWeight.w600,
              color: AppThemes.colors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
