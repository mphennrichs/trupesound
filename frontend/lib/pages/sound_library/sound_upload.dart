import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';
import 'package:trupe_sound/pages/custom/dashed_container.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/sound_library/service/storage_service.dart';

class SoundUploadPage extends ConsumerStatefulWidget {
  const SoundUploadPage({super.key});

  @override
  ConsumerState<SoundUploadPage> createState() => _SoundUploadPageState();
}

class _SoundUploadPageState extends ConsumerState<SoundUploadPage> {
  final _nameController = TextEditingController();
  SoundCategory? _selectedCategory;
  PlatformFile? _selectedFile;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _canSave(bool storageReady) =>
      storageReady &&
      _selectedFile != null &&
      _nameController.text.isNotEmpty &&
      _selectedCategory != null &&
      !_isUploading;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
        _errorMessage = null;
        _uploadProgress = 0.0;
      });
    }
  }

  Future<void> _upload() async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
      _uploadProgress = 0.0;
    });

    try {
      final storageService = await ref.read(storageServiceProvider.future);
      final url = await storageService.uploadSound(
        localFilePath: _selectedFile!.path!,
        fileName: _selectedFile!.name,
        onProgress: (progress) => setState(() => _uploadProgress = progress),
      );

      final newSound = SoundModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        category: _selectedCategory!,
        duration: Duration.zero,
        url: url,
        createdAt: DateTime.now(),
      );

      await ref.read(soundsProvider.notifier).addSound(newSound);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _isUploading = false;
        _errorMessage = e.toString();
      });
    }
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
          onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildDropzone(AppLocalizations l10n) {
    return DashedContainer(
      onTap: _isUploading ? null : _pickFile,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppThemes.spacings.doubleValue),
        child:
            _selectedFile == null
                ? _buildPickerPrompt(l10n)
                : _buildSelectedFile(),
      ),
    );
  }

  Widget _buildPickerPrompt(AppLocalizations l10n) {
    return Column(
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
          onPressed: _pickFile,
          child: Text(l10n.browseFiles),
        ),
      ],
    );
  }

  Widget _buildSelectedFile() {
    return Column(
      children: [
        Icon(Icons.audio_file, color: AppThemes.colors.primaryColor, size: 40),
        AppThemes.spacings.singleSpace,
        Text(
          _selectedFile!.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppThemes.spacings.singleValue / 2),
        TextButton(
          onPressed: _isUploading ? null : _pickFile,
          child: Text(
            AppLocalizations.of(context)!.changeFile,
            style: TextStyle(color: AppThemes.colors.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(AppLocalizations l10n) {
    final hasProgress = _isUploading || _uploadProgress > 0;
    final hasError = _errorMessage != null;
    if (!hasProgress && !hasError) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: AppThemes.spacings.singleValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasProgress) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isUploading ? l10n.uploading : l10n.uploadComplete,
                  style: TextStyle(color: AppThemes.colors.textColor),
                ),
                Text(
                  '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: AppThemes.colors.textColor),
                ),
              ],
            ),
            SizedBox(height: AppThemes.spacings.singleValue / 2),
            LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: AppThemes.colors.borderColor,
              valueColor: AlwaysStoppedAnimation(AppThemes.colors.primaryColor),
              borderRadius: AppThemes.borders.defaultBorderRadius,
            ),
          ],
          if (hasError) ...[
            SizedBox(height: AppThemes.spacings.singleValue / 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                SizedBox(width: AppThemes.spacings.singleValue / 2),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
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

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    bool storageReady,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: Colors.white)),
        ),
        AppThemes.spacings.singleSpace,
        ElevatedButton(
          style: AppThemes.buttons.primaryButtonStyle,
          onPressed: _canSave(storageReady) ? _upload : null,
          child: Row(
            children: [
              const Icon(Icons.note_add_outlined, color: Colors.white, size: 18),
              SizedBox(width: AppThemes.spacings.singleValue / 2),
              Text(l10n.save, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageBanner(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppThemes.spacings.singleValue),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 16),
          SizedBox(width: AppThemes.spacings.singleValue / 2),
          Expanded(
            child: Text(
              l10n.storageNotConfigured,
              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final storageAsync = ref.watch(storageServiceProvider);
    final storageReady = storageAsync.hasValue;
    final categories =
        SoundCategory.values.where((c) => c != SoundCategory.all).toList();

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
              _buildHeader(context, l10n),
              AppThemes.spacings.singleSpace,
              if (storageAsync.hasError) _buildStorageBanner(l10n),
              _buildDropzone(l10n),
              AppThemes.spacings.singleSpace,
              _buildProgressSection(l10n),
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
                onChanged: (val) => setState(() => _selectedCategory = val),
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
              _buildFooter(context, l10n, storageReady),
            ],
          ),
        ),
      ),
    );
  }
}
