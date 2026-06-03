import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

class ActiveTag extends StatelessWidget {
  const ActiveTag({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: AppThemes.borders.defaultBorderRadius,
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Text(
        l10n.active.toUpperCase(),
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: AppThemes.texts.verySmallFontSize,
        ),
      ),
    );
  }
}
