import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/sounds_table.dart';

class SoundLibraryPage extends ConsumerWidget {
  const SoundLibraryPage({super.key});

  Widget _buildFilters(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(onTap: () {}, child: SoundCategory.effect.getLabel(context)),
          AppThemes.spacings.singleSpace,
          InkWell(onTap: () {}, child: SoundCategory.ambient.getLabel(context)),
          AppThemes.spacings.singleSpace,
          InkWell(onTap: () {}, child: SoundCategory.song.getLabel(context)),
          AppThemes.spacings.singleSpace,
          VerticalDivider(color: AppThemes.colors.borderColor, thickness: 1),
          AppThemes.spacings.singleSpace,
          InkWell(onTap: () {}, child: SoundCategory.all.getLabel(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppThemes.spacings.doubleValue,
        horizontal: AppThemes.spacings.doubleValue,
      ),
      decoration: BoxDecoration(color: AppThemes.colors.backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitle(
            title: l10n.soundLibraryTitle,
            description: l10n.soundLibraryDescription,
          ),
          AppThemes.spacings.singleSpace,
          _buildFilters(context),
          AppThemes.spacings.doubleSpace,
          const Expanded(child: SoundsTable()),
        ],
      ),
    );
  }
}
