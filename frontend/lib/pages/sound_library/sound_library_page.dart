import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/sound_library/providers/storage_mode_provider.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';
import 'package:trupe_sound/pages/sound_library/sounds_table.dart';
import 'package:trupe_sound/pages/sound_library/sound_upload.dart';

class SoundLibraryPage extends ConsumerStatefulWidget {
  const SoundLibraryPage({super.key});

  @override
  ConsumerState<SoundLibraryPage> createState() => _SoundLibraryPageState();
}

class _SoundLibraryPageState extends ConsumerState<SoundLibraryPage> {
  bool _isSyncing = false;

  Future<void> _sync() async {
    setState(() => _isSyncing = true);
    try {
      await ref.read(dioProvider).post('/v1/sounds/sync');
      ref.invalidate(soundsProvider);
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

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

  Widget _buildActionButton(BuildContext context, AppLocalizations l10n, StorageMode mode) {
    if (mode == StorageMode.local) {
      return ElevatedButton(
        style: AppThemes.buttons.primaryButtonStyle,
        onPressed: _isSyncing ? null : _sync,
        child: Row(
          children: [
            _isSyncing
                ? SizedBox(
                    width: AppThemes.texts.h1FontSize,
                    height: AppThemes.texts.h1FontSize,
                    child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(
                    Icons.sync,
                    color: Colors.white,
                    size: AppThemes.texts.h1FontSize,
                  ),
            SizedBox(width: AppThemes.spacings.singleValue / 2),
            Text(
              l10n.syncSounds,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppThemes.texts.normalFontSize,
              ),
            ),
          ],
        ),
      );
    }

    if (mode == StorageMode.cloud) {
      return ElevatedButton(
        style: AppThemes.buttons.primaryButtonStyle,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const SoundUploadPage(),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
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
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modeAsync = ref.watch(storageModeProvider);
    final mode = modeAsync.when(
      data: (m) => m,
      loading: () => StorageMode.unknown,
      error: (e, s) => StorageMode.unknown,
    );

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
              _buildActionButton(context, l10n, mode),
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
