import 'package:trupe_sound/pages/plays/models/play.dart';

class PlayRepository {
  static final PlayRepository _singleton = PlayRepository._internal();

  factory PlayRepository() {
    return _singleton;
  }

  PlayRepository._internal();

  final Map<int, Play> plays = {};

  List<Play> list() {
    return plays.values.toList();
  }

  Play? save(Play play) {
    plays[play.id] = play;
    return play;
  }

  Play? get(int id) {
    return plays[id];
  }
}
