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
  static const AppCards cards = AppCards();
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

class AppCards {
  const AppCards();
  // 13.0 * 2
  final double width = 200;
  final double height = 300;
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
  final Color hintTextColor = const Color(0x66A69DB8);
  final Color primaryColor = const Color(0xFF5417cf);
  final Color backgroundColor = const Color(0xFF0c0914);
  final Color borderColor = const Color(0xFF2e2938);
  final Color cardColor = const Color(0xFF161121);

  final Color lightAmber = const Color(0xFFFFFBEB);
  final Color amber200 = const Color(0xFFFFE082);
  final Color darkAmber = const Color(0xFFFF6F00);

  final Color lightGreen = const Color(0xFFC8E6C9);
  final Color green200 = const Color(0xFFA5D6A7);
  final Color darkGreen = const Color(0xFF1B5E20);

  final Color lightPurple = const Color(0xFFE1BEE7);
  final Color purple200 = const Color(0xFFCE93D8);
  final Color darkPurple = const Color(0xFF4A148C);

  final Color lightGrey = const Color(0xFFF5F5F5);
  final Color grey200 = const Color(0xFFEEEEEE);
  final Color darkGrey = const Color(0xFF212121);
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

  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppThemes.colors.primaryColor,
    foregroundColor: Colors.white,
    overlayColor: Colors.black.withValues(alpha: 0.1),
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: AppThemes.borders.defaultBorder,
    textStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: AppThemes.texts.normalFontSize,
    ),
  );

  ButtonStyle get panicButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.red.withValues(alpha: 0.1),
    foregroundColor: Colors.red,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: AppThemes.borders.defaultBorderRadius,
      side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
    ),
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: AppThemes.texts.normalFontSize,
    ),
  );
}
