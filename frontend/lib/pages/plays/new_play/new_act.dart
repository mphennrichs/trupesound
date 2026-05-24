import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numerus/numerus.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/dashed_container.dart';
import 'package:trupe_sound/pages/plays/provider/play_form_provider.dart';

class NewAct extends HookConsumerWidget {
  final int? playId;
  const NewAct({super.key, this.playId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scripts = ref.watch(
      playFormControllerProvider(playId).select((s) => s.actScripts),
    );
    final notifier = ref.read(playFormControllerProvider(playId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.scriptOrganization,
          style: TextStyle(
            color: AppThemes.colors.textColor,
            fontSize: AppThemes.texts.normalFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppThemes.spacings.singleSpace,
        ...scripts.asMap().entries.map(
          (entry) => _ActItem(
            index: entry.key,
            initialText: entry.value,
            playId: playId,
          ),
        ),
        DashedContainer(
          padding: EdgeInsets.symmetric(
            vertical: AppThemes.spacings.singleValue,
            horizontal: AppThemes.spacings.singleValue,
          ),
          onTap: notifier.addAct,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle,
                color: AppThemes.colors.textColor,
                size: AppThemes.texts.h1FontSize,
              ),
              SizedBox(width: AppThemes.spacings.singleValue / 2),
              Text(
                l10n.addAct,
                style: TextStyle(
                  color: AppThemes.colors.textColor,
                  fontSize: AppThemes.texts.normalFontSize,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActItem extends HookConsumerWidget {
  final int index;
  final String initialText;
  final int? playId;

  const _ActItem({required this.index, required this.initialText, this.playId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final roman = (index + 1).toRomanNumeralString() ?? "";
    final controller = useTextEditingController(text: initialText);
    final notifier = ref.read(playFormControllerProvider(playId).notifier);

    return Padding(
      padding: EdgeInsets.only(bottom: AppThemes.spacings.doubleValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${l10n.act} $roman',
                style: TextStyle(
                  color: AppThemes.colors.textColor,
                  fontSize: AppThemes.texts.normalFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => notifier.removeAct(index),
                icon: Icon(
                  Icons.delete_outline,
                  color: AppThemes.colors.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            onChanged: (val) => notifier.updateActScript(index, val),
            maxLines: 8,
            minLines: 4,
            style: TextStyle(
              color: AppThemes.colors.textColor,
              fontSize: AppThemes.texts.normalFontSize,
            ),
            decoration: InputDecoration(
              hintText: l10n.pasteActHint(l10n.act, roman),
              hintStyle: TextStyle(color: AppThemes.colors.hintTextColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppThemes.borders.defaultBorderRadius,
                borderSide: BorderSide(color: AppThemes.colors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppThemes.borders.defaultBorderRadius,
                borderSide: BorderSide(
                  color: AppThemes.colors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
