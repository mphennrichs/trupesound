import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  Icon _getIcon() {
    return Icon(
      Icons.search_off,
      color: AppThemes.colors.primaryColor,
      size: 64,
    );
  }

  Text _getHttpCode() {
    return Text(
      '404',
      style: TextStyle(fontSize: 62, fontWeight: FontWeight.w900),
    );
  }

  Text _getTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.pageNotFound,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Text _getDescription(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.pageNotFoundDescription,
      style: TextStyle(fontSize: 18),
    );
  }

  TextButton _getBackToHomePageButton(BuildContext context) {
    return AppThemes.buttons.primaryButtonStyle(
      AppLocalizations.of(context)!.back,
      () => context.goNamed(NavigationPage.plays.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //all assets link
              _getIcon(),
              _getHttpCode(),
              AppThemes.spacings.singleSpace,
              _getTitle(context),
              AppThemes.spacings.singleSpace,
              _getDescription(context),
              AppThemes.spacings.doubleSpace,
              _getBackToHomePageButton(context),
              AppThemes.spacings.doubleSpace,
            ],
          ),
        ),
      ),
    );
  }
}
