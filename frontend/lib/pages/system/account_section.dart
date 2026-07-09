import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/auth/provider/auth_provider.dart';
import 'package:trupe_sound/pages/custom/delete_confirmation_dialog.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.accountSectionTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppThemes.texts.normalFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppThemes.spacings.singleValue),
        Container(
          padding: EdgeInsets.all(AppThemes.spacings.singleValue),
          decoration: BoxDecoration(
            color: AppThemes.colors.cardColor,
            borderRadius: AppThemes.borders.defaultBorderRadius,
            border: Border.all(color: AppThemes.colors.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.logoutDescription,
                  style: TextStyle(color: AppThemes.colors.textColor),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final confirmed = await DeleteConfirmationDialog.show(
                    context,
                    title: l10n.logoutConfirmTitle,
                    message: l10n.logoutConfirmMessage,
                  );

                  if (confirmed == true) {
                    await ref.read(authProvider.notifier).logout();
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: Text(
                  l10n.logoutButton,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
