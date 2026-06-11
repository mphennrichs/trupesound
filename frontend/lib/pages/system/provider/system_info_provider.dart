import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';

part 'system_info_provider.g.dart';

@Riverpod(keepAlive: true)
Future<String> applicationId(Ref ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.post('/v1/app/init');
  final data = response.data;
  if (data is! Map) throw Exception('Unexpected response from /app/init');
  return data['appId'] as String;
}

/// Identifies the quantity of sounds per category using data from [soundsProvider].
@riverpod
Map<SoundCategory, int> soundsByCategory(Ref ref) {
  final counts = ref.watch(soundCountsByCategoryProvider);
  return counts;
}
