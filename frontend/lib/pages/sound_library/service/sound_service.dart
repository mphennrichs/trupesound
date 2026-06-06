import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';

part 'sound_service.g.dart';

@Riverpod(keepAlive: true)
SoundService soundService(Ref ref) => SoundService(ref.read(dioProvider));

class SoundService {
  final Dio _dio;

  SoundService(this._dio);

  Future<List<SoundModel>> list() async {
    final response = await _dio.get('/v1/sounds');
    final data = response.data as List<dynamic>;
    return data.map((e) => SoundModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SoundModel> add({
    required String name,
    required SoundCategory category,
    required String url,
    required int durationMs,
  }) async {
    final response = await _dio.post('/v1/sounds', data: {
      'name': name,
      'category': category.name,
      'url': url,
      'durationMs': durationMs,
    });
    return SoundModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SoundModel> update(int id, {String? name, SoundCategory? category}) async {
    final response = await _dio.patch('/v1/sounds/$id', data: {
      if (name != null) 'name': name,
      if (category != null) 'category': category.name,
    });
    return SoundModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/v1/sounds/$id');
  }
}
