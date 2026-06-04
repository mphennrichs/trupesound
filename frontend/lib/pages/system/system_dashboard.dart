import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'dart:io' show Platform;
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';

import 'package:trupe_sound/pages/system/info_card.dart';
import 'package:trupe_sound/pages/system/stat_card.dart';

class SystemDashboard extends StatelessWidget {
  final String appId;
  final AsyncValue<List<dynamic>> playsAsync; // Changed to be more specific
  final Map<SoundCategory, int> categories;

  const SystemDashboard({
    super.key,
    required this.appId,
    required this.playsAsync,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final playsCount = playsAsync.when(
      data: (plays) => (plays).length.toString(),
      loading: () => '...',
      error: (_, _) => '!',
    );

    final totalSounds = categories.values.fold(0, (sum, count) => sum + count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoCard(
          title: l10n.applicationID,
          subtitle: l10n.applicationIDDescription,
          value: appId,
          isSelectable: true,
        ),
        SizedBox(height: AppThemes.spacings.doubleValue),
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
            SizedBox(width: AppThemes.spacings.singleValue),
            Expanded(
              child: StatCard(
                label: l10n.platform,
                value: _getPlatformName(),
                icon: Icons.computer,
              ),
            ),
          ],
        ),
        SizedBox(height: AppThemes.spacings.doubleValue),
        Text(
          l10n.soundsPerCategory,
          style: TextStyle(
            color: AppThemes.colors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppThemes.spacings.singleValue),
        ...categories.entries.map(
          (e) => _buildCategoryItem(e.key.getText(context), e.value),
        ), // Use e.key.name
      ],
    );
  }

  Widget _buildCategoryItem(String name, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(name, style: TextStyle(color: AppThemes.colors.textColor)),
          const Spacer(),
          Text(
            count.toString(),
            style: TextStyle(
              color: AppThemes.colors.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    return 'Mobile/Unknown';
  }
}
