import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trupe_sound/common/app_themes.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppThemes.colors.cardColor,
      highlightColor: AppThemes.colors.borderColor.withValues(alpha: 0.1),
      child: Container(
        width: AppThemes.cards.width,
        height: AppThemes.cards.height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppThemes.colors.cardColor,
          borderRadius: AppThemes.borders.defaultBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 180,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 120,
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
                (_) => Container(width: 80, height: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
