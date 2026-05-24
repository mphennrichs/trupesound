import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/models/play.dart';
import 'package:trupe_sound/models/act.dart';
import 'package:trupe_sound/pages/plays/provider/play_visual_utils.dart';

part 'play_form_provider.g.dart';

class PlayFormState {
  final String title;
  final String author;
  final List<String> actScripts;
  final IconData? icon;
  final Color? backgroundColor;
  final bool isSaving;

  PlayFormState({
    this.title = '',
    this.author = '',
    this.actScripts = const [],
    this.icon,
    this.backgroundColor,
    this.isSaving = false,
  });

  PlayFormState copyWith({
    String? title,
    String? author,
    List<String>? actScripts,
    IconData? icon,
    Color? backgroundColor,
    bool? isSaving,
  }) {
    return PlayFormState(
      title: title ?? this.title,
      author: author ?? this.author,
      actScripts: actScripts ?? this.actScripts,
      icon: icon ?? this.icon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  PlayFormState copyWithNullIcon({
    String? title,
    String? author,
    List<String>? actScripts,
    IconData? icon,
    Color? backgroundColor,
    bool? isSaving,
  }) {
    return PlayFormState(
      title: title ?? this.title,
      author: author ?? this.author,
      actScripts: actScripts ?? this.actScripts,
      icon: null,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

@riverpod
class PlayFormController extends _$PlayFormController {
  @override
  PlayFormState build() => PlayFormState(
    icon: PlayVisualUtils.getRandomIcon(),
    backgroundColor: PlayVisualUtils.getRandomColor(),
  );

  void updateTitle(String value) => state = state.copyWith(title: value);
  void updateAuthor(String value) => state = state.copyWith(author: value);

  void updateIcon(IconData value) {
    if (value == state.icon) {
      state = state.copyWithNullIcon();
    } else {
      state = state.copyWith(icon: value);
    }
  }

  void updateBackgroundColor(Color value) {
    if (value == state.backgroundColor) {
      state = state.copyWith(backgroundColor: AppThemes.colors.cardColor);
    } else {
      state = state.copyWith(backgroundColor: value);
    }
  }

  void addAct() {
    state = state.copyWith(actScripts: [...state.actScripts, '']);
  }

  void removeAct(int index) {
    final newList = List<String>.from(state.actScripts)..removeAt(index);
    state = state.copyWith(actScripts: newList);
  }

  void updateActScript(int index, String script) {
    final newList = List<String>.from(state.actScripts);
    newList[index] = script;
    state = state.copyWith(actScripts: newList);
  }

  Play toModel() {
    return Play(
      id: 0,
      title: state.title,
      author: state.author,
      creationDate: DateTime.now(),
      lastModifyDate: DateTime.now(),
      cueCount: 0,
      icon: state.icon,
      backgroundColor: state.backgroundColor,
      acts: state.actScripts
          .asMap()
          .entries
          .map((e) => Act(number: e.key + 1, name: '', script: e.value))
          .toList(),
    );
  }
}
