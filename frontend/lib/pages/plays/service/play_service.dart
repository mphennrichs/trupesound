import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/models/play.dart';
import 'package:trupe_sound/pages/plays/service/repository.dart';
// Assuming a global dioProvider exists
// import 'package:trupe_sound/common/providers/dio_provider.dart';

part 'play_service.g.dart';

@Riverpod()
PlayService playService(Ref ref) {
  // Replace with your actual dioProvider
  // final dio = ref.watch(dioProvider);
  // return PlayService(Dio());
  return PlayService();
}

class PlayService {
  // final Dio _dio;

  // PlayService(this._dio);

  final PlayRepository playRepo = PlayRepository();

  Future<List<Play>> list() async {
    try {
      return playRepo.list();
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
      return playRepo.save(play);
    } catch (e) {
      return null;
    }
  }

  Future<Play?> update(Play play) async {
    try {
      // await _dio.put('/plays/${play.id}', data: play.toJson());

      Play currentPlay = playRepo
          .get(play.id)!
          .copyWith(
            title: play.title,
            author: play.author,
            acts: play.acts,
            cueCount: play.cueCount,
            icon: play.icon,
            backgroundColor: play.backgroundColor,
            lastModifyDate: DateTime.now(),
          );
      return playRepo.save(currentPlay);
    } catch (e) {
      return null;
    }
  }

  Future<bool> delete(int id) async {
    try {
      // await _dio.delete('/plays/$id');
      // return true;
      Play currentPlay = playRepo
          .get(id)!
          .copyWith(archived: true, lastModifyDate: DateTime.now());
      playRepo.save(currentPlay);
      return true;
    } catch (e) {
      return false;
    }
  }
}
