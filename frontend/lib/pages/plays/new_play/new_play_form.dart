import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/plays/new_play/new_act.dart';
import 'package:trupe_sound/pages/plays/new_play/plays_provider.dart';
import 'package:trupe_sound/pages/plays/provider/play_form_provider.dart';

class NewPlayForm extends HookConsumerWidget {
  const NewPlayForm({super.key});

  Widget _buildBanner(IconData? icon, Color? backgroundColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppThemes.spacings.singleValue),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppThemes.borders.defaultBorderRadius,
      ),
      child: Center(child: Icon(icon, color: Colors.white, size: 48)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(playFormControllerProvider.notifier);
    final state = ref.watch(playFormControllerProvider);

    // Hooks for controllers
    final titleController = useTextEditingController();
    final authorController = useTextEditingController();

    useEffect(() {
      void titleListener() => notifier.updateTitle(titleController.text);
      void authorListener() => notifier.updateAuthor(authorController.text);

      titleController.addListener(titleListener);
      authorController.addListener(authorListener);

      return () {
        titleController.removeListener(titleListener);
        authorController.removeListener(authorListener);
      };
    }, [titleController, authorController]);

    Future<void> saveAndStartEditing() async {
      final newPlay = notifier.toModel();

      final savedPlay = await ref.read(playsProvider.notifier).addPlay(newPlay);

      if (savedPlay != null && context.mounted) {
        context.pushNamed(
          NavigationPage.soundscape.name,
          pathParameters: {'playId': savedPlay.id.toString()},
        );
      }
      // You might want to show an error message if savedPlay is null
    }

    Widget buildButtons() {
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
            style: AppThemes.buttons.primaryButtonStyle,
            onPressed: saveAndStartEditing,
            child: Text(l10n.createAndStartEditing),
          ),
        ],
      );
    }

    final title = CustomTitle(
      title: l10n.newPlayFormTitle,
      description: l10n.newPlayFormDescription,
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
          AppThemes.spacings.singleSpace,
          _buildBanner(state.icon, state.backgroundColor),
          AppThemes.spacings.singleSpace,
          Row(
            children: [
              Expanded(
                child: CustomTextInput(
                  title: l10n.playTitleLabel,
                  exampleText: l10n.playTitleHint,
                  controller: titleController,
                ),
              ),
              SizedBox(width: AppThemes.spacings.doubleValue),
              Expanded(
                child: CustomTextInput(
                  title: l10n.playAuthorLabel,
                  exampleText: l10n.playAuthorHint,
                  controller: authorController,
                ),
              ),
            ],
          ),
          AppThemes.spacings.doubleSpace,
          const NewAct(),
          AppThemes.spacings.doubleSpace,
          buildButtons(),
        ],
      ),
    );
  }
}
