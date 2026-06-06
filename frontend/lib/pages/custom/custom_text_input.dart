import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class CustomTextInput extends StatelessWidget {
  final String title;
  final String exampleText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextInput({
    super.key,
    required this.title,
    required this.exampleText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppThemes.colors.textColor,
            fontSize: AppThemes.texts.normalFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(
            color: AppThemes.colors.textColor,
            fontSize: AppThemes.texts.normalFontSize,
          ),
          decoration: InputDecoration(
            hintText: exampleText,
            hintStyle: TextStyle(color: AppThemes.colors.hintTextColor),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppThemes.borders.defaultBorderRadius,
              borderSide: BorderSide(color: AppThemes.colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppThemes.borders.defaultBorderRadius,
              borderSide: BorderSide(
                color: AppThemes.colors.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
