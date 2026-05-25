import 'package:flutter/material.dart';
import 'package:trupe_sound/pages/plays/models/act.dart';

class Play {
  final int id;
  final String title;
  final String author;
  final List<Act> acts;
  final DateTime creationDate;
  final DateTime lastModifyDate;
  final int cueCount;
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
    required this.cueCount,
    this.icon,
    this.backgroundColor,
  });

  Play copyWith({
    int? id,
    String? title,
    String? author,
    List<Act>? acts,
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
      cueCount: cueCount ?? this.cueCount,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
