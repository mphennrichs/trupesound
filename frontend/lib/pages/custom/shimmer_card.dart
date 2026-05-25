import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trupe_sound/common/app_themes.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = AppThemes.cards.calculateWidth(screenWidth);
    final cardHeight = AppThemes.cards.calculateHeight(cardWidth);

    return Shimmer.fromColors(
      baseColor: AppThemes.colors.cardColor,
      highlightColor: AppThemes.colors.borderColor.withValues(alpha: 0.1),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppThemes.colors.cardColor,
          borderRadius: AppThemes.borders.defaultBorderRadius,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(color: Colors.white24, thickness: 1),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    2,
                    (_) =>
                        Container(width: 40, height: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
