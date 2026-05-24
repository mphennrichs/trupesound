import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/models/play.dart';
// Assuming a global dioProvider exists
// import 'package:trupe_sound/common/providers/dio_provider.dart';

part 'play_service.g.dart';

@riverpod
PlayService playService(Ref ref) {
  // Replace with your actual dioProvider
  // final dio = ref.watch(dioProvider);
  return PlayService(Dio());
}

class PlayService {
  final Dio _dio;

  Map<int, Play> plays = {};

  PlayService(this._dio);

  Future<List<Play>> list() async {
    try {
      return plays.values.toList();
      // final response = await _dio.get('/plays');
      // final List data = response.data;
      // // Mapping logic depends on your model having fromJson
      // // return data.map((json) => Play.fromJson(json)).toList();
      // return []; // Placeholder for actual implementation
    } catch (e) {
      return [];
    }
  }

  Future<Play?> save(Play play) async {
    try {
      // final response = await _dio.post('/plays', data: play.toJson());
      // return Play.fromJson(response.data);
      // return play; // Placeholder
      plays[play.id] = play;
      return play;
    } catch (e) {
      return null;
    }
  }

  Future<Play?> update(Play play) async {
    try {
      // await _dio.put('/plays/${play.id}', data: play.toJson());
      Play currentPlay = plays[play.id]!.copyWith(
        title: play.title,
        author: play.author,
        acts: play.acts,
        cueCount: play.cueCount,
        icon: play.icon,
        backgroundColor: play.backgroundColor,
        lastModifyDate: DateTime.now(),
      );
      plays[play.id] = currentPlay;
      return currentPlay;
    } catch (e) {
      return null;
    }
  }

  Future<bool> delete(int id) async {
    try {
      // await _dio.delete('/plays/$id');
      // return true;
      plays.remove(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
