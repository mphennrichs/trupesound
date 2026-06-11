import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/pages/custom/custom_app_bar.dart';
import 'package:trupe_sound/pages/custom/custom_bottom_navigation_bar.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_navigation_rail.dart';
import 'package:trupe_sound/pages/custom/navigation_item.dart';
import 'package:trupe_sound/pages/custom/providers/panic_provider.dart';

class BasePage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BasePage({super.key, required this.navigationShell});

  @override
  ConsumerState<BasePage> createState() => _BasePageState();
}

class _BasePageState extends ConsumerState<BasePage> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      ref.read(panicActionProvider.notifier).execute();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationItem> topNavigationDestinations = [
      NavigationItem(
        NavigationPage.plays,
        (context) => AppLocalizations.of(context)!.playsTitle,
        Icon(Icons.theater_comedy_outlined, color: AppThemes.colors.textColor),
        Icon(Icons.theater_comedy, color: AppThemes.colors.primaryColor),
      ),
      NavigationItem(
        NavigationPage.soundscape,
        (context) => AppLocalizations.of(context)!.soundscape,
        Icon(Icons.surround_sound_outlined, color: AppThemes.colors.textColor),
        Icon(Icons.surround_sound, color: AppThemes.colors.primaryColor),
      ),
      NavigationItem(
        NavigationPage.soundLibrary,
        (context) => AppLocalizations.of(context)!.soundLibraryTitle,
        Icon(Icons.library_music_outlined, color: AppThemes.colors.textColor),
        Icon(Icons.library_music, color: AppThemes.colors.primaryColor),
      ),
      NavigationItem(
        NavigationPage.system,
        (context) => AppLocalizations.of(context)!.systemTitle,
        Icon(Icons.settings_outlined, color: AppThemes.colors.textColor),
        Icon(Icons.settings, color: AppThemes.colors.primaryColor),
      ),
    ];

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Row(
          children: [
            CustomNavigationRail(
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: (index) {
                widget.navigationShell.goBranch(
                  index,
                  initialLocation: index == widget.navigationShell.currentIndex,
                );
              },
              topDestinations: topNavigationDestinations,
            ),
            VerticalDivider(
              thickness: 0.5,
              width: 0.5,
              color: AppThemes.colors.borderColor,
            ),
            Expanded(child: widget.navigationShell),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}
