import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/volume_slider/volume_slider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppThemes.colors.backgroundColor,
      shape: Border(
        bottom: BorderSide(width: 0.5, color: AppThemes.colors.borderColor),
      ),
      title: Row(
        children: [
          Icon(
            Icons.my_library_music_outlined,
            color: AppThemes.colors.textColor,
          ),
          AppThemes.spacings.singleSpace,
          Text(
            AppThemes.appName,
            style: TextStyle(
              fontSize: AppThemes.texts.h1FontSize,
              color: AppThemes.colors.textColor,
            ),
          ),
        ],
      ),
      actions: [const VolumeSlider(), AppThemes.spacings.singleSpace],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
