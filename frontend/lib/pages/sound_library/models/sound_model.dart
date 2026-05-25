import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

enum SoundCategory { EFFECT, AMBIENT, SONG, ALL }

extension SoundCategoryExtension on SoundCategory {
  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case SoundCategory.EFFECT:
        return l10n.effect;
      case SoundCategory.AMBIENT:
        return l10n.ambient;
      case SoundCategory.SONG:
        return l10n.song;
      case SoundCategory.ALL:
        return l10n.all;
    }
  }

  CategoryColors getColors() {
    switch (this) {
      case SoundCategory.EFFECT:
        return CategoryColors(
          text: AppThemes.colors.darkGreen,
          background: AppThemes.colors.lightGreen,
          elements: AppThemes.colors.green200,
        );
      case SoundCategory.AMBIENT:
        return CategoryColors(
          text: AppThemes.colors.darkGrey,
          background: AppThemes.colors.lightGrey,
          elements: AppThemes.colors.grey200,
        );
      case SoundCategory.SONG:
        return CategoryColors(
          text: AppThemes.colors.darkAmber,
          background: AppThemes.colors.lightAmber,
          elements: AppThemes.colors.amber200,
        );
      case SoundCategory.ALL:
        return CategoryColors(
          text: AppThemes.colors.darkGreen,
          background: AppThemes.colors.lightGreen,
          elements: AppThemes.colors.green200,
        );
    }
  }
}

class CategoryColors {
  Color text;
  Color background;
  Color elements;
  CategoryColors({
    required this.text,
    required this.background,
    required this.elements,
  });
}

class SoundModel {
  final String id;
  final String name;
  final String category;
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
    String? category,
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
