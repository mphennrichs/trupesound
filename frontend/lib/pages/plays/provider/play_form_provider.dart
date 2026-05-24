import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/models/play.dart';
import 'package:trupe_sound/models/act.dart';

part 'play_form_provider.g.dart';

class PlayFormState {
  final String title;
  final String author;
  final List<String> actScripts;
  final bool isSaving;

  PlayFormState({
    this.title = '',
    this.author = '',
    this.actScripts = const [],
    this.isSaving = false,
  });

  PlayFormState copyWith({
    String? title,
    String? author,
    List<String>? actScripts,
    bool? isSaving,
  }) {
    return PlayFormState(
      title: title ?? this.title,
      author: author ?? this.author,
      actScripts: actScripts ?? this.actScripts,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

@riverpod
class PlayFormController extends _$PlayFormController {
  @override
  PlayFormState build() => PlayFormState();

  void updateTitle(String value) => state = state.copyWith(title: value);
  void updateAuthor(String value) => state = state.copyWith(author: value);

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
      acts: state.actScripts
          .asMap()
          .entries
          .map((e) => Act(number: e.key + 1, name: '', script: e.value))
          .toList(),
    );
  }
}
