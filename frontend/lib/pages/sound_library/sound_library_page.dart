import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/sounds_table.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';

class SoundLibraryPage extends ConsumerWidget {
  const SoundLibraryPage({super.key});

  Widget _buildFilterItem(
    BuildContext context,
    WidgetRef ref,
    SoundCategory category,
    bool isActive,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => ref.read(soundCategoryFilterProvider.notifier).set(category),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            border: isActive
                ? Border(
                    bottom: BorderSide(
                      color: AppThemes.colors.primaryColor,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: category.getLabel(context, true),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, WidgetRef ref) {
    final activeCategory = ref.watch(soundCategoryFilterProvider);

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterItem(
            context,
            ref,
            SoundCategory.effect,
            activeCategory == SoundCategory.effect,
          ),
          AppThemes.spacings.singleSpace,
          _buildFilterItem(
            context,
            ref,
            SoundCategory.ambient,
            activeCategory == SoundCategory.ambient,
          ),
          AppThemes.spacings.singleSpace,
          _buildFilterItem(
            context,
            ref,
            SoundCategory.song,
            activeCategory == SoundCategory.song,
          ),
          AppThemes.spacings.singleSpace,
          VerticalDivider(color: AppThemes.colors.borderColor, thickness: 1),
          AppThemes.spacings.singleSpace,
          _buildFilterItem(
            context,
            ref,
            SoundCategory.all,
            activeCategory == SoundCategory.all,
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTitle(
                title: l10n.soundLibraryTitle,
                description: l10n.soundLibraryDescription,
              ),
              ElevatedButton(
                style: AppThemes.buttons.primaryButtonStyle,
                onPressed: () => context.goNamed(NavigationPage.plays.name),
                child: Row(
                  children: [
                    Icon(
                      Icons.upload,
                      color: Colors.white,
                      size: AppThemes.texts.h1FontSize,
                    ),
                    SizedBox(width: AppThemes.spacings.singleValue / 2),
                    Text(
                      l10n.addSound,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppThemes.texts.normalFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppThemes.spacings.singleSpace,
          _buildFilters(context, ref),
          AppThemes.spacings.doubleSpace,
          const Expanded(child: SoundsTable()),
        ],
      ),
    );
  }
}
