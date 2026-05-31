import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_breadcrumb.dart';
import 'package:trupe_sound/pages/plays/new_play/new_play_form.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';

class NewPlayPage extends HookConsumerWidget {
  final int? playId;
  const NewPlayPage({super.key, this.playId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playsAsync = ref.watch(playsProvider);

    return playsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          const Scaffold(body: Center(child: Text('Error loading play'))),
      data: (plays) {
        final isEditing = playId != null;

        if (isEditing && !plays.any((p) => p.id == playId)) {
          return const Scaffold(body: Center(child: Text('Play not found')));
        }

        final breadcrumbWidget = CustomBreadcrumb(
          items: [
            BreadcrumbItem(label: l10n.playsTitle, onTap: () => context.pop()),
            BreadcrumbItem(
              label: isEditing ? l10n.editPlayFormTitle : l10n.createNewPlay,
            ),
          ],
        );

        return Scaffold(
          backgroundColor: AppThemes.colors.backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // breadcrumbWidget,
                  AppThemes.spacings.singleSpace,
                  NewPlayForm(playId: playId),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
