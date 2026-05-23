import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';

class NewPlayForm extends StatefulWidget {
  const NewPlayForm({super.key});

  @override
  State<NewPlayForm> createState() => _NewPlayFormState();
}

class _NewPlayFormState extends State<NewPlayForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppThemes.colors.cardColor,
        borderRadius: AppThemes.borders.defaultBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitle(
            title: l10n.newPlayFormTitle,
            description: l10n.newPlayFormDescription,
          ),
          AppThemes.spacings.doubleSpace,
          AppThemes.spacings.doubleSpace,
          Row(
            children: [
              Expanded(
                child: CustomTextInput(
                  title: l10n.playTitleLabel,
                  exampleText: l10n.playTitleHint,
                  controller: _titleController,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: CustomTextInput(
                  title: l10n.playAuthorDirectorLabel,
                  exampleText: l10n.playAuthorDirectorHint,
                  controller: _authorController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
