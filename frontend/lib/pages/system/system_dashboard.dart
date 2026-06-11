import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/storage_mode_provider.dart';
import 'package:trupe_sound/pages/system/info_card.dart';
import 'package:trupe_sound/pages/system/stat_card.dart';

class SystemDashboard extends ConsumerWidget {
  final String appId;
  final AsyncValue<List<Play>> playsAsync;
  final Map<SoundCategory, int> categories;

  const SystemDashboard({
    super.key,
    required this.appId,
    required this.playsAsync,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final storageMode = ref.watch(storageModeProvider).when(
          data: (m) => m,
          loading: () => StorageMode.unknown,
          error: (_, _) => StorageMode.unknown,
        );
    final storageModeLabel = switch (storageMode) {
      StorageMode.cloud => 'Cloud (SeaweedFS)',
      StorageMode.local => 'Local',
      StorageMode.unknown => '—',
    };

    final playsCount = playsAsync.when(
      data: (plays) => plays.length.toString(),
      loading: () => '...',
      error: (_, _) => '!',
    );

    final totalSounds = categories.values.fold(0, (sum, c) => sum + c);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
          title: l10n.applicationID,
          subtitle: l10n.applicationIDDescription,
          value: appId,
          isSelectable: true,
        ),
        SizedBox(height: AppThemes.spacings.singleValue),
        InfoCard(
          title: l10n.storageInfoTitle,
          subtitle: l10n.storageInfoDescription,
          value: storageModeLabel,
        ),
        SizedBox(height: AppThemes.spacings.singleValue),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: l10n.totalPlays,
                value: playsCount,
                icon: Icons.play_circle_outline,
              ),
            ),
            SizedBox(width: AppThemes.spacings.singleValue),
            Expanded(
              child: StatCard(
                label: l10n.totalSounds,
                value: totalSounds.toString(),
                icon: Icons.audiotrack,
              ),
            ),
          ],
        ),
        SizedBox(height: AppThemes.spacings.doubleValue),
        Text(
          l10n.soundsPerCategory,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppThemes.texts.normalFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppThemes.spacings.singleValue),
        Container(
          decoration: BoxDecoration(
            color: AppThemes.colors.cardColor,
            borderRadius: AppThemes.borders.defaultBorderRadius,
            border: Border.all(color: AppThemes.colors.borderColor),
          ),
          child: Column(
            children: categories.entries
                .where((e) => e.key != SoundCategory.all)
                .toList()
                .asMap()
                .entries
                .map((indexed) {
                  final isLast =
                      indexed.key ==
                      categories.entries
                              .where((e) => e.key != SoundCategory.all)
                              .length -
                          1;
                  return _CategoryRow(
                    entry: indexed.value,
                    total: totalSounds,
                    showDivider: !isLast,
                  );
                })
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final MapEntry<SoundCategory, int> entry;
  final int total;
  final bool showDivider;

  const _CategoryRow({
    required this.entry,
    required this.total,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? entry.value / total : 0.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppThemes.spacings.singleValue,
            vertical: AppThemes.spacings.singleValue * 0.75,
          ),
          child: Row(
            children: [
              SizedBox(width: 80, child: entry.key.getLabel(context, true)),
              SizedBox(width: AppThemes.spacings.singleValue),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 6,
                    backgroundColor: AppThemes.colors.borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppThemes.colors.primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppThemes.spacings.singleValue),
              SizedBox(
                width: 28,
                child: Text(
                  entry.value.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppThemes.texts.smallFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: AppThemes.colors.borderColor),
      ],
    );
  }
}
