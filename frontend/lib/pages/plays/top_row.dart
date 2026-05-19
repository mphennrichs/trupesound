import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  Text _getTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.playsTitle,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: AppThemes.texts.h1FontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Text _getDescription(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.playsDescription,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: AppThemes.texts.normalFontSize,
        color: AppThemes.colors.textColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_getTitle(context), _getDescription(context)],
        ),
      ],
    );
  }
}
