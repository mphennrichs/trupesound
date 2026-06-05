import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:trupe_sound/pages/system/service/app_data_service.dart';

part 'system_info_provider.g.dart';

@Riverpod(keepAlive: true)
Future<String> applicationId(Ref ref) {
  return ref.read(appDataServiceProvider).loadOrCreateAppId();
}

/// Identifies the quantity of sounds per category using data from [soundsProvider].
@riverpod
Map<SoundCategory, int> soundsByCategory(Ref ref) {
  final counts = ref.watch(soundCountsByCategoryProvider);
  return counts;
}
