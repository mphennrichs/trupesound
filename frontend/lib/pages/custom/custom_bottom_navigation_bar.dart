import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/providers/panic_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: AppThemes.colors.backgroundColor,
        border: Border(
          top: BorderSide(width: 0.5, color: AppThemes.colors.borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppThemes.buttons.panicButton(
            l10n.panicStop('esc').toUpperCase(),
            () {
              ref.read(panicActionProvider.notifier).execute();
            },
          ),
          AppThemes.spacings.singleSpace,
        ],
      ),
    );
  }
}
