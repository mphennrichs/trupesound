import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/pages/custom/placeholder_card.dart';
import 'package:trupe_sound/pages/plays/top_row.dart';

class Plays extends StatelessWidget {
  const Plays({super.key});

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            // TODO: Open dialog or navigate to create play page
          },
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
          children: <Widget>[TopRow(), AppThemes.spacings.singleSpace, content],
        ),
      ),
    );
  }
}
