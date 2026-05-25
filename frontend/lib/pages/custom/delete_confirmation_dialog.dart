import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) =>
          DeleteConfirmationDialog(title: title, message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppThemes.colors.cardColor,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      content: Text(
        message,
        style: TextStyle(color: AppThemes.colors.textColor),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppThemes.colors.textColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            l10n.delete,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
