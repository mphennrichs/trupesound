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

  factory Play.fromJson(Map<String, dynamic> json, {List<ActModel> acts = const []}) {
    final iconCode = json['icon'] as int?;
    final bgHex = json['backgroundColor'] as String?;
    return Play(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      acts: acts,
      creationDate: DateTime.now(),
      lastModifyDate: DateTime.now(),
      archived: false,
      icon: iconCode != null ? IconData(iconCode, fontFamily: 'MaterialIcons') : null,
      backgroundColor: bgHex != null ? Color(int.parse(bgHex.padLeft(8, '0'), radix: 16)) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    if (icon != null) 'icon': icon!.codePoint,
    if (backgroundColor != null) 'backgroundColor': backgroundColor!.value.toRadixString(16),
  };

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
