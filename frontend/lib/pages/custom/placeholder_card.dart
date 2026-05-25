import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/dashed_container.dart';

class PlaceholderCard extends StatelessWidget {
  final VoidCallback onTap;

  const PlaceholderCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = AppThemes.cards.calculateWidth(screenWidth);
    final cardHeight = AppThemes.cards.calculateHeight(cardWidth);

    return DashedContainer(
      onTap: onTap,
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.all(24),
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle,
                size: AppThemes.texts.h1FontSize * 4,
                color: AppThemes.colors.primaryColor.withValues(alpha: 0.7),
              ),
              AppThemes.spacings.doubleSpace,
              Text(
                l10n.createNewPlay,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppThemes.texts.h1FontSize,
                  fontWeight: FontWeight.w600,
                  color: AppThemes.colors.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
