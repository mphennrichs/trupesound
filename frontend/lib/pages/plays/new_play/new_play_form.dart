import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_text_input.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/plays/new_play/new_act.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/plays/provider/play_form_provider.dart';
import 'package:trupe_sound/pages/plays/provider/play_visual_utils.dart';

class NewPlayForm extends HookConsumerWidget {
  final int? playId;
  const NewPlayForm({super.key, this.playId});

  void _showColorPicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppThemes.colors.cardColor,
          title: Text(
            l10n.selectBannerColor,
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 320,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: PlayVisualUtils.defaultColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(playFormControllerProvider(playId).notifier)
                        .updateBackgroundColor(color);
                    context.pop();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showIconPicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppThemes.colors.cardColor,
          title: Text(l10n.selectIcon, style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: 320,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: PlayVisualUtils.defaultIcons.map((icon) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(playFormControllerProvider(playId).notifier)
                          .updateIcon(icon);
                      context.pop();
                    },
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner(
    BuildContext context,
    WidgetRef ref,
    IconData? icon,
    Color? backgroundColor,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppThemes.borders.defaultBorderRadius,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: AppThemes.texts.h1FontSize * 2,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBannerAction(
                    tooltip: l10n.editColor,
                    icon: Icons.edit,
                    onTap: () => _showColorPicker(context, ref),
                  ),
                  const SizedBox(height: 8),
                  _buildBannerAction(
                    tooltip: l10n.editIcon,
                    icon: Icons.image_outlined,
                    onTap: () => _showIconPicker(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerAction({
    required String tooltip,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: AppThemes.texts.normalFontSize,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.watch(playFormControllerProvider(playId).notifier);
    final state = ref.watch(playFormControllerProvider(playId));

    // Hooks for controllers
    final titleController = useTextEditingController(text: state.title);
    final authorController = useTextEditingController(text: state.author);

    // Sync controllers if state changes from external initialization
    useEffect(() {
      if (titleController.text != state.title) {
        titleController.text = state.title;
      }
      if (authorController.text != state.author) {
        authorController.text = state.author;
      }
      return null;
    }, [state.title, state.author]);

    useEffect(() {
      void titleListener() => notifier.updateTitle(titleController.text);
      void authorListener() => notifier.updateAuthor(authorController.text);
      titleController.addListener(titleListener);
      authorController.addListener(authorListener);
      return () {
        titleController.removeListener(titleListener);
        authorController.removeListener(authorListener);
      };
    }, [titleController, authorController, notifier]);

    Future<void> saveAndStartEditing(bool isEditing) async {
      final play = notifier.toModel();
      final playsNotifier = ref.read(playsProvider.notifier);

      if (isEditing) {
        await playsNotifier.updatePlay(play);
      } else {
        await playsNotifier.addPlay(play);
      }

      if (isEditing) {
        context.pop();
      } else {
        if (context.mounted) {
          context.goNamed(
            NavigationPage.soundscape.name,
            pathParameters: {'playId': play.id.toString()},
          );
        }
      }
    }

    final isEditing = playId != null;

    Widget buildButtons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              context.pop();
            },
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
            onPressed: () => saveAndStartEditing(isEditing),
            child: Text(isEditing ? l10n.save : l10n.createAndStartEditing),
          ),
        ],
      );
    }

    print("playId: $playId | isEditing: $isEditing ");

    final title = CustomTitle(
      title: isEditing ? l10n.editPlayFormTitle : l10n.newPlayFormTitle,
      description: isEditing
          ? l10n.editPlayFormDescription
          : l10n.newPlayFormDescription,
    );

    return Container(
      key: ValueKey(playId), // Ensures hook state resets when switching playId
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
          _buildBanner(context, ref, state.icon, state.backgroundColor),
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
          NewAct(playId: playId),
          AppThemes.spacings.doubleSpace,
          buildButtons(),
        ],
      ),
    );
  }
}
