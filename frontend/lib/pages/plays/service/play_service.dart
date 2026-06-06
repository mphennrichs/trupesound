import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';
import 'package:trupe_sound/pages/plays/models/act.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';

part 'play_service.g.dart';

@Riverpod()
PlayService playService(Ref ref) {
  return PlayService(ref.watch(dioProvider));
}

class PlayService {
  final Dio _dio;

  PlayService(this._dio);

  Future<List<Play>> list() async {
    final response = await _dio.get('/v1/plays');
    final plays = (response.data['data'] as List).cast<Map<String, dynamic>>();

    return Future.wait(
      plays.map((playJson) async {
        final acts = await _fetchActs(playJson['id'] as int);
        return Play.fromJson(playJson, acts: acts);
      }),
    );
  }

  Future<Play?> save(Play play) async {
    final playResponse = await _dio.post('/v1/plays', data: play.toJson());
    final saved = Play.fromJson(playResponse.data as Map<String, dynamic>);

    final savedActs = await Future.wait(
      play.acts.map((act) async {
        final r = await _dio.post('/v1/acts', data: {
          'playId': saved.id,
          ...act.toJson(),
        });
        return ActModel.fromJson(r.data as Map<String, dynamic>);
      }),
    );

    return saved.copyWith(acts: savedActs);
  }

  Future<Play?> update(Play play) async {
    await _dio.put('/v1/plays/${play.id}', data: play.toJson());

    final serverActs = await _fetchActs(play.id);
    final serverByNumber = {for (final a in serverActs) a.number: a};
    final newByNumber = {for (final a in play.acts) a.number: a};

    final toDelete = serverActs.where((a) => !newByNumber.containsKey(a.number));

    await Future.wait(toDelete.map((a) => _dio.delete('/v1/acts/${a.id}')));

    final updatedActs = await Future.wait(
      play.acts.map((act) async {
        final existing = serverByNumber[act.number];
        if (existing != null) {
          final r = await _dio.put('/v1/acts/${existing.id}', data: act.toJson());
          return ActModel.fromJson(r.data as Map<String, dynamic>)
              .copyWith(cues: act.cues);
        } else {
          final r = await _dio.post('/v1/acts', data: {
            'playId': play.id,
            ...act.toJson(),
          });
          return ActModel.fromJson(r.data as Map<String, dynamic>);
        }
      }),
    );

    return play.copyWith(acts: updatedActs);
  }

  Future<bool> delete(int id) async {
    await _dio.delete('/v1/plays/$id');
    return true;
  }

  Future<List<ActModel>> _fetchActs(int playId) async {
    final r = await _dio.get('/v1/acts', queryParameters: {'playId': playId});
    return (r.data['data'] as List)
        .map((e) => ActModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
