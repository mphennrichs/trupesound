import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';

class SoundCueSearchDialog extends ConsumerWidget {
  const SoundCueSearchDialog({super.key});

  Widget _buildSearchContainer() {
    return Text(
      'search here',
      style: TextStyle(
        color: AppThemes.colors.textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildButton(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {},
          style: AppThemes.buttons.secondaryButtonStyle,
          child: Text(
            l10n.save,
            style: TextStyle(fontSize: AppThemes.texts.smallFontSize),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsAsync = ref.watch(filteredSoundsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(AppThemes.spacings.singleValue),
        decoration: BoxDecoration(
          color: AppThemes.colors.cardColor,
          borderRadius: AppThemes.borders.defaultBorderRadius,
          border: Border.all(color: AppThemes.colors.borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchContainer(),
            Divider(color: AppThemes.colors.borderColor),
            AppThemes.spacings.singleSpace,
            soundsAsync.when(
              data: (sounds) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sounds
                    .map(
                      (sound) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          sound.name,
                          style: TextStyle(color: AppThemes.colors.textColor),
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text(
                'Error: $err',
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
            AppThemes.spacings.singleSpace,
            Divider(color: AppThemes.colors.borderColor),
            _buildButton(l10n),
          ],
        ),
      ),
    );
  }
}
