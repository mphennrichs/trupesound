import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/system/account_section.dart';
import 'package:trupe_sound/pages/system/provider/system_info_provider.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/system/system_dashboard.dart';

class SystemOverviewPage extends ConsumerWidget {
  const SystemOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final appId = ref.watch(applicationIdProvider).when(
          data: (id) => id,
          loading: () => '...',
          error: (err, _) => 'Error: $err',
        );
    final playsAsync = ref.watch(playsProvider);
    final categories = ref.watch(soundsByCategoryProvider);

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
              title: l10n.systemTitle,
              description: l10n.systemDescription,
            ),
            AppThemes.spacings.singleSpace,
            SystemDashboard(
              appId: appId,
              playsAsync: playsAsync,
              categories: categories,
            ),
            AppThemes.spacings.doubleSpace,
            const AccountSection(),
          ],
        ),
      ),
    );
  }
}
