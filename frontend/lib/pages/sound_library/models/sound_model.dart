import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

enum SoundCategory { effect, ambient, song, all }

extension SoundCategoryExtension on SoundCategory {
  Container getLabel(BuildContext context, bool small) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _getColors().border),
        borderRadius: AppThemes.borders.defaultBorderRadius,
        color: _getColors().background,
      ),
      padding: EdgeInsets.all(AppThemes.spacings.singleValue / 2),
      child: Text(
        _getText(context),
        style: TextStyle(
          color: _getColors().text,
          fontSize: small
              ? AppThemes.texts.smallFontSize
              : AppThemes.texts.normalFontSize,
        ),
      ),
    );
  }

  String _getText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case SoundCategory.effect:
        return l10n.effect;
      case SoundCategory.ambient:
        return l10n.ambient;
      case SoundCategory.song:
        return l10n.song;
      case SoundCategory.all:
        return l10n.all;
    }
  }

  CategoryColors _getColors() {
    double alpha = 0.3;

    switch (this) {
      case SoundCategory.effect:
        return CategoryColors(
          text: AppThemes.colors.lightGreen,
          background: AppThemes.colors.darkGreen.withValues(alpha: alpha),
          border: AppThemes.colors.darkGreen,
        );
      case SoundCategory.ambient:
        return CategoryColors(
          text: AppThemes.colors.lightBlue,
          background: AppThemes.colors.darkBlue.withValues(alpha: alpha),
          border: AppThemes.colors.darkBlue,
        );
      case SoundCategory.song:
        return CategoryColors(
          text: AppThemes.colors.lightAmber,
          background: AppThemes.colors.darkAmber.withValues(alpha: alpha),
          border: AppThemes.colors.darkAmber,
        );
      case SoundCategory.all:
        return CategoryColors(
          text: AppThemes.colors.lightGrey,
          background: AppThemes.colors.darkGrey.withValues(alpha: alpha),
          border: AppThemes.colors.darkGrey,
        );
    }
  }
}

class CategoryColors {
  Color text;
  Color background;
  Color border;
  CategoryColors({
    required this.text,
    required this.background,
    required this.border,
  });
}

class SoundModel {
  final String id;
  final String name;
  final SoundCategory category;
  final Duration duration;
  final String url;
  final bool archived;
  final DateTime createdAt;

  SoundModel({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.url,
    required this.createdAt,
    this.archived = false,
  });

  // Logic for persistence or comparison can be added here
  SoundModel copyWith({
    String? name,
    SoundCategory? category,
    bool? archived,
    DateTime? createdAt,
  }) {
    return SoundModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      duration: duration,
      url: url,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
