import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          foregroundPainter: _DashedBorderPainter(
            color: AppThemes.colors.primaryColor,
            borderRadius: AppThemes.borders.defaultBorderRadius,
          ),
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppThemes.colors.primaryColor.withValues(alpha: 0.1),
              borderRadius: AppThemes.borders.defaultBorderRadius,
            ),
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
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final BorderRadius borderRadius;

  _DashedBorderPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Path path = Path()
      ..addRRect(borderRadius.toRRect(Offset.zero & size));

    const double dashWidth = 5.0;
    const double dashSpace = 3.5;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
