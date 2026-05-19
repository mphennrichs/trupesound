import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class DashedContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const DashedContainer({
    super.key,
    required this.child,
    this.onTap,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          foregroundPainter: _DashedBorderPainter(
            color: AppThemes.colors.borderColor,
            borderRadius: AppThemes.borders.defaultBorderRadius,
          ),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: AppThemes.colors.cardColor,
              borderRadius: AppThemes.borders.defaultBorderRadius,
            ),
            child: child,
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
