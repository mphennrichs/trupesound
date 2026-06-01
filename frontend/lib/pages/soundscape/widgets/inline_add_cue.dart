import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/pages/soundscape/widgets/sound_cue_search_dialog.dart';

class InlineAddCue extends StatefulWidget {
  const InlineAddCue({super.key});

  @override
  State<InlineAddCue> createState() => _InlineAddCueState();
}

class _InlineAddCueState extends State<InlineAddCue> {
  bool _isHovered = false;
  bool _isDialogOpen = false;

  Future<void> _showSearchDialog(BuildContext context, Offset position) async {
    setState(() {
      _isDialogOpen = true;
    });

    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: const SoundCueSearchDialog(),
          ),
        ],
      ),
    );

    if (mounted) {
      setState(() {
        _isDialogOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppThemes.colors.primaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (details) =>
            _showSearchDialog(context, details.globalPosition),
        child: Container(
          height: AppThemes.spacings.doubleValue,
          alignment: Alignment.center,
          width: double.infinity,
          color: Colors.transparent, // Ensures the entire area is hit-testable
          child: (_isHovered || _isDialogOpen)
              ? Row(
                  children: [
                    Expanded(child: Container(height: 2, color: primary)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.1),
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
      ),
    );
  }
}
