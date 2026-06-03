import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trupe_sound/common/app_themes.dart';

class HotkeyCaptureDialog extends StatefulWidget {
  final ValueChanged<String> onHotkeyCaptured;

  const HotkeyCaptureDialog({super.key, required this.onHotkeyCaptured});

  @override
  State<HotkeyCaptureDialog> createState() => _HotkeyCaptureDialogState();
}

class _HotkeyCaptureDialogState extends State<HotkeyCaptureDialog> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          final label = event.logicalKey.keyLabel;
          // Only capture single character keys (A-Z, 0-9, etc.)
          if (label.length == 1) {
            widget.onHotkeyCaptured(label);
            Navigator.of(context).pop();
          }
        }
      },
      child: AlertDialog(
        backgroundColor: AppThemes.colors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppThemes.borders.defaultBorderRadius,
          side: BorderSide(color: AppThemes.colors.borderColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard,
              color: AppThemes.colors.primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Press a key to set hotkey',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
