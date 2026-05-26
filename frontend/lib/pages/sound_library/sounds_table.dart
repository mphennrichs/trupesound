import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/custom/delete_confirmation_dialog.dart';

class SoundsTable extends ConsumerWidget {
  const SoundsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsAsync = ref.watch(filteredSoundsProvider);

    return soundsAsync.when(
      data: (sounds) => _buildDataTable(context, ref, sounds, false),
      loading: () => _buildDataTable(context, ref, null, true),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  //TODO: if the screen is to small we got a bottom overflow.
  Widget _buildDataTable(
    BuildContext context,
    WidgetRef ref,
    List<SoundModel>? sounds,
    bool isLoading,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(dividerColor: AppThemes.colors.borderColor),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppThemes.colors.borderColor),
          borderRadius: AppThemes.borders.defaultBorderRadius,
        ),
        child: ClipRRect(
          borderRadius: AppThemes.borders.defaultBorderRadius,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowHeight: 48,
                      dividerThickness: 0.2,
                      headingRowColor: WidgetStateProperty.all(
                        AppThemes.colors.cardColor,
                      ),
                      columnSpacing: AppThemes.spacings.singleValue,
                      horizontalMargin: AppThemes.spacings.singleValue,
                      columns: [
                        _buildColumn(l10n.previewColumn),
                        _buildColumn(l10n.soundNameColumn),
                        _buildColumn(l10n.categoryColumn),
                        _buildColumn(l10n.durationColumn),
                        _buildColumn(l10n.actionsColumn),
                      ],
                      rows: isLoading
                          ? List.generate(5, (_) => _buildPlaceholderRow())
                          : sounds!
                                .map(
                                  (sound) => _buildDataRow(context, ref, sound),
                                )
                                .toList(),
                    ),
                  ),
                ),
              ),
              Divider(
                // height: 0.5,
                thickness: 0.5,
                color: AppThemes.colors.borderColor,
              ),
              _buildFooter(context, isLoading ? 0 : sounds?.length ?? 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, int totalSounds) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppThemes.colors.cardColor,
      padding: EdgeInsets.symmetric(
        horizontal: AppThemes.spacings.singleValue,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.showingSounds(
              0,
              3,
              12,
            ), // Consider updating l10n to take variables
            style: TextStyle(
              color: AppThemes.colors.textColor,
              fontSize: AppThemes.texts.smallFontSize,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left, size: 20),
                color: AppThemes.colors.textColor,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right, size: 20),
                color: AppThemes.colors.textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  DataColumn _buildColumn(String label) {
    return DataColumn(
      label: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: AppThemes.colors.textColor,
          fontWeight: FontWeight.bold,
          fontSize: AppThemes.texts.smallFontSize,
        ),
      ),
    );
  }

  DataRow _buildPlaceholderRow() {
    return DataRow(
      cells: List.generate(
        5,
        (_) => DataCell(
          Shimmer.fromColors(
            baseColor: Colors.white.withValues(alpha: 0.05),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Container(
              height: 16,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, WidgetRef ref, SoundModel asset) {
    return DataRow(
      cells: [
        DataCell(
          Icon(
            Icons.play_circle_outline,
            color: AppThemes.colors.primaryColor,
            size: AppThemes.texts.h1FontSize * 1.5,
          ),
        ),
        DataCell(Text(asset.name, style: const TextStyle(color: Colors.white))),
        DataCell(asset.category.getLabel(context)),
        DataCell(
          Text(
            _formatDuration(asset.duration),
            style: TextStyle(color: AppThemes.colors.textColor),
          ),
        ),
        DataCell(_buildMenu(context, ref, asset)),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref, SoundModel sound) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: l10n.edit,
          onPressed: () {
            print("EDIT sound ${sound.name}");
          },
          icon: Icon(Icons.edit_outlined, size: AppThemes.texts.h1FontSize),
          color: Colors.white,
        ),
        IconButton(
          tooltip: l10n.delete,
          onPressed: () async {
            final confirmed = await DeleteConfirmationDialog.show(
              context,
              title: l10n.delete,
              message: l10n.deleteSoundConfirmationMessage,
            );

            if (confirmed == true && context.mounted) {
              ref.read(soundRepositoryProvider.notifier).deleteSound(sound.id);
            }
          },
          icon: Icon(Icons.delete_outline, size: AppThemes.texts.h1FontSize),
          color: Colors.red,
        ),
      ],
    );
  }
}
