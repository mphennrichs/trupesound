import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class InlineAddCue extends StatefulWidget {
  const InlineAddCue({super.key});

  @override
  State<InlineAddCue> createState() => _InlineAddCueState();
}

class _InlineAddCueState extends State<InlineAddCue> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primary = AppThemes.colors.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        height: 16,
        width: double.infinity,
        color: Colors.transparent, // Ensures the entire area is hit-testable
        child: _isHovered
            ? Row(
                children: [
                  Expanded(child: Container(height: 2, color: primary)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.add_circle,
                      color: primary,
                      size: AppThemes.texts.h1FontSize,
                      shadows: [
                        Shadow(
                          color: primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container(height: 2, color: primary)),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
