import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_breadcrumb.dart';

class NewPlayPage extends StatelessWidget {
  const NewPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final breadcrumbWidget = CustomBreadcrumb(
      items: [
        BreadcrumbItem(label: l10n.playsTitle, onTap: () => context.pop()),
        BreadcrumbItem(label: l10n.createNewPlay),
      ],
    );

    return Scaffold(
      backgroundColor: AppThemes.colors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            breadcrumbWidget,
            AppThemes.spacings.singleSpace,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: AppThemes.colors.cardColor,
                borderRadius: AppThemes.borders.defaultBorderRadius,
              ),
              child: const Text("Play form"),
            ),
          ],
        ),
      ),
    );
  }
}
