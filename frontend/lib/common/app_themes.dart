import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  //Texts
  static const String appName = 'Trupe Sound';

  static const AppTexts texts = AppTexts();
  static const AppSpacings spacings = AppSpacings();
  static const AppColors colors = AppColors();
  static const AppBorders borders = AppBorders();
  static const AppButtons buttons = AppButtons();
}

class AppTexts {
  const AppTexts();
  // 13.0 * 2
  final double h1FontSize = 20;
  final double h2FontSize = 16;
  final double normalFontSize = 14;
  final double smallFontSize = 12;
  final double calculatedHintHeight = 38.0; // 14.0 + 24.0
}

class AppSpacings {
  const AppSpacings();

  final double singleValue = 13.0;
  final double doubleValue = 26.0;
  final SizedBox singleSpace = const SizedBox(height: 13.0, width: 13.0);
  final SizedBox doubleSpace = const SizedBox(height: 26.0, width: 13.0);
}

class AppColors {
  const AppColors();

  final Color textColor = const Color(0xFFa69db8);
  final Color primaryColor = const Color(0xFF5417cf);
  final Color backgroundColor = const Color(0xFF0c0914);
  final Color borderColor = const Color(0xFF2e2938);
  final Color cardColor = const Color(0xFF161121);
}

class AppBorders {
  const AppBorders();

  final BorderRadius defaultBorderRadius = const BorderRadius.all(
    Radius.circular(7),
  );

  OutlinedBorder get defaultBorder =>
      RoundedRectangleBorder(borderRadius: defaultBorderRadius);
}

class AppButtons {
  const AppButtons();

  TextButton primaryButtonStyle(String text, VoidCallback buttonfunction) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          AppThemes.colors.primaryColor,
        ),
        fixedSize: WidgetStateProperty.all<Size>(const Size(192.21, 44)),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          AppThemes.borders.defaultBorder,
        ),
      ),
      onPressed: buttonfunction,
      child: Text(
        text,
        style: TextStyle(
          color: AppThemes.colors.textColor,
          fontWeight: FontWeight.w600,
          fontSize: AppThemes.texts.normalFontSize,
        ),
      ),
    );
  }

  ElevatedButton panicButton(String text, VoidCallback buttonfunction) {
    return ElevatedButton.icon(
      onPressed: buttonfunction,
      icon: const Icon(Icons.error_outline, size: 18),
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppThemes.texts.normalFontSize,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        foregroundColor: Colors.red,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: AppThemes.borders.defaultBorderRadius,
          side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}
