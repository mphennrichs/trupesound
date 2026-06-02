import 'package:flutter/material.dart';
import 'package:trupe_sound/pages/plays/models/act.dart';

class Play {
  final int id;
  final String title;
  final String author;
  final List<ActModel> acts;
  final DateTime creationDate;
  final DateTime lastModifyDate;
  final bool archived;
  final IconData? icon;
  final Color? backgroundColor;

  const Play({
    required this.id,
    required this.title,
    required this.author,
    required this.acts,
    required this.creationDate,
    required this.lastModifyDate,
    this.archived = false,
    this.icon,
    this.backgroundColor,
  });

  int get cueCount {
    return acts.fold(0, (sum, act) => sum + act.cues.length);
  }

  Play copyWith({
    int? id,
    String? title,
    String? author,
    List<ActModel>? acts,
    DateTime? creationDate,
    DateTime? lastModifyDate,
    bool? archived,
    int? cueCount,
    IconData? icon,
    Color? backgroundColor,
  }) {
    return Play(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      acts: acts ?? this.acts,
      creationDate: creationDate ?? this.creationDate,
      lastModifyDate: lastModifyDate ?? this.lastModifyDate,
      archived: archived ?? this.archived,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
