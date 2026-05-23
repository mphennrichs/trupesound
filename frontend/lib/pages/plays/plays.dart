import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/placeholder_card.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';

class Plays extends StatelessWidget {
  const Plays({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Widget content = GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppThemes.spacings.doubleValue,
        mainAxisSpacing: AppThemes.spacings.doubleValue,
        childAspectRatio: 4 / 5,
      ),
      children: [
        PlaceholderCard(
          onTap: () => context.pushNamed(NavigationPage.newPlay.name),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppThemes.colors.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: AppThemes.spacings.doubleValue,
          horizontal: AppThemes.spacings.doubleValue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTitle(
              title: l10n.playsTitle,
              description: l10n.playsDescription,
            ),
            AppThemes.spacings.singleSpace,
            content,
          ],
        ),
      ),
    );
  }
}
