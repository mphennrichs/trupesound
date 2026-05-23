import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';
import 'package:trupe_sound/pages/plays/new_play/new_act.dart';

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

  Widget buttonRow() {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            l10n.cancel,
            style: TextStyle(
              color: AppThemes.colors.textColor,
              fontSize: AppThemes.texts.normalFontSize,
            ),
          ),
        ),
        SizedBox(width: AppThemes.spacings.singleValue),
        ElevatedButton(
          onPressed: () => context.pushNamed(NavigationPage.soundscape.name),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemes.colors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppThemes.borders.defaultBorderRadius,
            ),
          ),
          child: Text(l10n.createAndStartEditing),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final title = CustomTitle(
      title: l10n.newPlayFormTitle,
      description: l10n.newPlayFormDescription,
    );

    final titleAuthorRow = Row(
      children: [
        Expanded(
          child: CustomTextInput(
            title: l10n.playTitleLabel,
            exampleText: l10n.playTitleHint,
            controller: _titleController,
          ),
        ),
        SizedBox(width: AppThemes.spacings.doubleValue),
        Expanded(
          child: CustomTextInput(
            title: l10n.playAuthorDirectorLabel,
            exampleText: l10n.playAuthorDirectorHint,
            controller: _authorController,
          ),
        ),
      ],
    );

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
          title,
          AppThemes.spacings.doubleSpace,
          AppThemes.spacings.doubleSpace,
          titleAuthorRow,
          AppThemes.spacings.doubleSpace,
          NewAct(),
          AppThemes.spacings.doubleSpace,
          buttonRow(),
        ],
      ),
    );
  }
}
