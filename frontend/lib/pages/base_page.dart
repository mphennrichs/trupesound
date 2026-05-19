import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/pages/custom/custom_app_bar.dart';
import 'package:trupe_sound/pages/custom/custom_bottom_navigation_bar.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_navigation_rail.dart';
import 'package:trupe_sound/pages/custom/navigation_item.dart';

class BasePage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const BasePage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<NavigationItem> topNavigationDestinations = [
      NavigationItem(
        NavigationPage.plays,
        (context) => AppLocalizations.of(context)!.playsTitle,
        Icon(Icons.theater_comedy_outlined, color: AppThemes.colors.textColor),
        Icon(Icons.theater_comedy, color: AppThemes.colors.primaryColor),
      ),
      NavigationItem(
        NavigationPage.soundLibrary,
        (context) => AppLocalizations.of(context)!.soundLibraryTitle,
        Icon(Icons.library_music_outlined, color: AppThemes.colors.textColor),
        Icon(Icons.library_music, color: AppThemes.colors.primaryColor),
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Row(
        children: [
          CustomNavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              // Navega para o ramo correspondente
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            topDestinations: topNavigationDestinations,
          ),
          VerticalDivider(
            thickness: 0.5,
            width: 0.5,
            color: AppThemes.colors.borderColor,
          ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
