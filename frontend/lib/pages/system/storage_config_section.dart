import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';
import 'package:trupe_sound/pages/sound_library/service/storage_service.dart';
import 'package:trupe_sound/pages/system/service/app_data_service.dart';

class StorageConfigSection extends ConsumerStatefulWidget {
  const StorageConfigSection({super.key});

  @override
  ConsumerState<StorageConfigSection> createState() =>
      _StorageConfigSectionState();
}

class _StorageConfigSectionState extends ConsumerState<StorageConfigSection> {
  final _endpointController = TextEditingController();
  final _accessKeyController = TextEditingController();
  final _secretKeyController = TextEditingController();
  bool _obscureSecret = true;
  bool _isSaving = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _accessKeyController.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await ref.read(appDataServiceProvider).loadStorageConfig();
    if (config != null && mounted) {
      setState(() {
        _endpointController.text = config.endpoint;
        _accessKeyController.text = config.accessKey;
        _secretKeyController.text = config.secretKey;
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _successMessage = null;
      _errorMessage = null;
    });

    try {
      final config = StorageConfig(
        endpoint: _endpointController.text.trim(),
        accessKey: _accessKeyController.text.trim(),
        secretKey: _secretKeyController.text.trim(),
      );
      await ref.read(appDataServiceProvider).saveStorageConfig(config);
      ref.invalidate(storageServiceProvider);
      if (mounted) {
        setState(() {
          _isSaving = false;
          _successMessage = AppLocalizations.of(context)!.storageSaved;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.storageSettingsTitle,
          style: TextStyle(
            color: AppThemes.colors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppThemes.spacings.singleValue / 2),
        Text(
          l10n.storageSettingsDescription,
          style: TextStyle(
            color: AppThemes.colors.hintTextColor,
            fontSize: AppThemes.texts.smallFontSize,
          ),
        ),
        AppThemes.spacings.singleSpace,
        Card(
          color: AppThemes.colors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppThemes.borders.defaultBorderRadius,
            side: BorderSide(color: AppThemes.colors.borderColor),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppThemes.spacings.singleValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextInput(
                  title: l10n.storageEndpoint,
                  exampleText: l10n.storageEndpointHint,
                  controller: _endpointController,
                ),
                AppThemes.spacings.singleSpace,
                CustomTextInput(
                  title: l10n.storageAccessKey,
                  exampleText: l10n.storageAccessKeyHint,
                  controller: _accessKeyController,
                ),
                AppThemes.spacings.singleSpace,
                CustomTextInput(
                  title: l10n.storageSecretKey,
                  exampleText: l10n.storageSecretKeyHint,
                  controller: _secretKeyController,
                  obscureText: _obscureSecret,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSecret
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppThemes.colors.hintTextColor,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureSecret = !_obscureSecret),
                  ),
                ),
                AppThemes.spacings.singleSpace,
                _buildFeedback(l10n),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: AppThemes.buttons.primaryButtonStyle,
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.save,
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback(AppLocalizations l10n) {
    if (_successMessage == null && _errorMessage == null) {
      return const SizedBox.shrink();
    }
    final isSuccess = _successMessage != null;
    return Padding(
      padding: EdgeInsets.only(bottom: AppThemes.spacings.singleValue),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            color: isSuccess ? Colors.greenAccent : Colors.redAccent,
            size: 16,
          ),
          SizedBox(width: AppThemes.spacings.singleValue / 2),
          Expanded(
            child: Text(
              isSuccess ? _successMessage! : _errorMessage!,
              style: TextStyle(
                color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
