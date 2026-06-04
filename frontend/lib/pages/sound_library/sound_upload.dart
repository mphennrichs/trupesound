import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';
import 'package:trupe_sound/pages/custom/dashed_container.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';

class SoundUploadPage extends ConsumerStatefulWidget {
  const SoundUploadPage({super.key});

  @override
  ConsumerState<SoundUploadPage> createState() => _SoundUploadPageState();
}

class _SoundUploadPageState extends ConsumerState<SoundUploadPage> {
  final _nameController = TextEditingController();
  SoundCategory? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          color: AppThemes.colors.primaryColor,
          size: 28,
        ),
        AppThemes.spacings.singleSpace,
        Text(
          l10n.addSound,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppThemes.texts.h1FontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: Colors.white)),
        ),
        AppThemes.spacings.singleSpace,
        ElevatedButton(
          style: AppThemes.buttons.primaryButtonStyle,
          onPressed: () {
            if (_nameController.text.isEmpty || _selectedCategory == null) {
              // TODO: Add proper validation feedback
              return;
            }

            final newSound = SoundModel(
              id: DateTime.now().millisecondsSinceEpoch,
              name: _nameController.text,
              category: _selectedCategory!,
              // Using placeholder values until file picking is implemented
              duration: const Duration(seconds: 0),
              url: 'temp_path',
              createdAt: DateTime.now(),
            );

            ref.read(soundsProvider.notifier).addSound(newSound).then((
              _,
            ) {
              if (context.mounted) Navigator.of(context).pop();
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.note_add_outlined,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: AppThemes.spacings.singleValue / 2),
              Text(l10n.save, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDragDropContent(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppThemes.spacings.doubleValue),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppThemes.spacings.singleValue),
            decoration: BoxDecoration(
              color: AppThemes.colors.darkPurple,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.upload_file,
              color: Colors.white,
              size: AppThemes.texts.h1FontSize,
            ),
          ),
          AppThemes.spacings.singleSpace,
          Text(
            l10n.dragAndDrop,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppThemes.spacings.singleValue / 2),
          Text(
            l10n.fileTypes,
            style: TextStyle(
              color: AppThemes.colors.hintTextColor,
              fontSize: AppThemes.texts.smallFontSize,
            ),
          ),
          AppThemes.spacings.singleSpace,
          ElevatedButton(
            style: AppThemes.buttons.primaryButtonStyle,
            onPressed: () {},
            child: Text(l10n.browseFiles),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppThemes.spacings.singleValue / 2),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: AppThemes.colors.textColor.withValues(alpha: 0.6),
          fontSize: AppThemes.texts.smallFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = SoundCategory.values
        .where((c) => c != SoundCategory.all)
        .toList();

    return Dialog(
      backgroundColor: AppThemes.colors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppThemes.borders.defaultBorderRadius,
      ),
      child: Container(
        width: 500,
        padding: EdgeInsets.all(AppThemes.spacings.doubleValue),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(context, l10n),
              AppThemes.spacings.singleSpace,

              // Upload Dropzone Area
              DashedContainer(
                onTap: () {}, // Implementation for file picker
                child: _buildDragDropContent(l10n),
              ),
              AppThemes.spacings.singleSpace,

              // Form Fields Section
              CustomTextInput(
                title: l10n.soundNameColumn,
                exampleText: l10n.soundNameHint,
                controller: _nameController,
              ),
              AppThemes.spacings.singleSpace,

              _buildFieldLabel(l10n.categoryColumn),
              DropdownButtonFormField<SoundCategory>(
                dropdownColor: AppThemes.colors.cardColor,
                isExpanded: true,
                style: const TextStyle(color: Colors.white),
                initialValue: _selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.getText(context)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppThemes.colors.backgroundColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppThemes.borders.defaultBorderRadius,
                    borderSide: BorderSide(color: AppThemes.colors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppThemes.borders.defaultBorderRadius,
                    borderSide: BorderSide(
                      color: AppThemes.colors.primaryColor,
                    ),
                  ),
                ),
              ),
              AppThemes.spacings.singleSpace,

              // Footer Section
              _buildFooter(context, l10n),
            ],
          ),
        ),
      ),
    );
  }
}
