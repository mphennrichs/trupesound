import 'package:flutter/material.dart';
import 'package:numerus/numerus.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/dashed_container.dart';

class NewAct extends StatefulWidget {
  const NewAct({super.key});

  @override
  State<NewAct> createState() => _NewActState();
}

class _NewActState extends State<NewAct> {
  final List<TextEditingController> _actControllers = [];

  void _addAct() {
    setState(() {
      _actControllers.add(TextEditingController());
    });
  }

  void _removeAct(int index) {
    setState(() {
      _actControllers[index].dispose();
      _actControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in _actControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
        ..._actControllers.asMap().entries.map((entry) {
          final int actNumber = entry.key + 1;
          final roman = actNumber.toRomanNumeralString();

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
                      onPressed: () => _removeAct(index),
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppThemes.colors.textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: entry.value,
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
                      borderSide: BorderSide(
                        color: AppThemes.colors.borderColor,
                      ),
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
        }),
        DashedContainer(
          padding: EdgeInsets.symmetric(
            vertical: AppThemes.spacings.singleValue,
            horizontal: AppThemes.spacings.singleValue,
          ),
          onTap: _addAct,
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
