import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/providers/audio_player_provider.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/sound_library/service/sound_service.dart';
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
    final audioState = ref.watch(audioPlayerProvider);
    final isPlaying = audioState.isPlayingId(asset.id);

    return DataRow(
      cells: [
        DataCell(
          IconButton(
            onPressed: () async {
              final dio = ref.read(dioProvider);
              final resp = await dio.get<Map<String, dynamic>>('/v1/sounds/${asset.id}/play-url');
              final url = (resp.data?['url'] as String?) ?? asset.url;
              await ref.read(audioPlayerProvider.notifier).play(asset.id, url);
            },
            icon: Icon(
              isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
              color: AppThemes.colors.primaryColor,
              size: AppThemes.texts.h1FontSize * 1.5,
            ),
          ),
        ),
        DataCell(Text(asset.name, style: const TextStyle(color: Colors.white))),
        DataCell(asset.category.getLabel(context, false)),
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
          onPressed: () async {
            final updated = await _SoundEditDialog.show(context, sound);
            if (updated != null && context.mounted) {
              ref.read(soundsProvider.notifier).updateSound(updated);
            }
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
              ref.read(soundsProvider.notifier).deleteSound(sound.id);
            }
          },
          icon: Icon(Icons.delete_outline, size: AppThemes.texts.h1FontSize),
          color: Colors.red,
        ),
      ],
    );
  }
}

class _SoundEditDialog extends ConsumerStatefulWidget {
  final SoundModel sound;
  const _SoundEditDialog({required this.sound});

  static Future<SoundModel?> show(BuildContext context, SoundModel sound) {
    return showDialog<SoundModel>(
      context: context,
      builder: (_) => _SoundEditDialog(sound: sound),
    );
  }

  @override
  ConsumerState<_SoundEditDialog> createState() => _SoundEditDialogState();
}

class _SoundEditDialogState extends ConsumerState<_SoundEditDialog> {
  late final TextEditingController _nameController;
  late SoundCategory _category;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sound.name);
    _category = widget.sound.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final updated = await ref.read(soundServiceProvider).update(
        widget.sound.id,
        name: _nameController.text.trim(),
        category: _category,
      );
      if (mounted) Navigator.of(context).pop(updated);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = SoundCategory.values.where((c) => c != SoundCategory.all).toList();

    return Dialog(
      backgroundColor: AppThemes.colors.cardColor,
      shape: RoundedRectangleBorder(borderRadius: AppThemes.borders.defaultBorderRadius),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(AppThemes.spacings.doubleValue),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_outlined, color: AppThemes.colors.primaryColor, size: 24),
                AppThemes.spacings.singleSpace,
                Text(
                  l10n.edit,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppThemes.texts.h1FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
            AppThemes.spacings.singleSpace,
            Text(
              l10n.soundNameColumn.toUpperCase(),
              style: TextStyle(
                color: AppThemes.colors.textColor.withValues(alpha: 0.6),
                fontSize: AppThemes.texts.smallFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppThemes.spacings.singleValue / 2),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppThemes.colors.backgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppThemes.borders.defaultBorderRadius,
                  borderSide: BorderSide(color: AppThemes.colors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppThemes.borders.defaultBorderRadius,
                  borderSide: BorderSide(color: AppThemes.colors.primaryColor),
                ),
              ),
            ),
            AppThemes.spacings.singleSpace,
            Text(
              l10n.categoryColumn.toUpperCase(),
              style: TextStyle(
                color: AppThemes.colors.textColor.withValues(alpha: 0.6),
                fontSize: AppThemes.texts.smallFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppThemes.spacings.singleValue / 2),
            DropdownButtonFormField<SoundCategory>(
              initialValue: _category,
              dropdownColor: AppThemes.colors.cardColor,
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c.getText(context)))).toList(),
              onChanged: (v) { if (v != null) setState(() => _category = v); },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppThemes.colors.backgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppThemes.borders.defaultBorderRadius,
                  borderSide: BorderSide(color: AppThemes.colors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppThemes.borders.defaultBorderRadius,
                  borderSide: BorderSide(color: AppThemes.colors.primaryColor),
                ),
              ),
            ),
            AppThemes.spacings.singleSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel, style: const TextStyle(color: Colors.white)),
                ),
                AppThemes.spacings.singleSpace,
                ElevatedButton(
                  style: AppThemes.buttons.primaryButtonStyle,
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(l10n.save, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
