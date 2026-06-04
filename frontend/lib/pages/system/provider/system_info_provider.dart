import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/sound_library/providers/sound_provider.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';
import 'package:uuid/uuid.dart';

part 'system_info_provider.g.dart';

/// Provides a unique Application ID generated at startup.
/// keepAlive is set to true to ensure the ID remains constant during the app lifecycle.
@Riverpod(keepAlive: true)
String applicationId(Ref ref) {
  return const Uuid().v4();
}

/// Identifies the quantity of sounds per category using data from [soundsProvider].
@riverpod
Map<SoundCategory, int> soundsByCategory(Ref ref) {
  final counts = ref.watch(soundCountsByCategoryProvider);
  return counts;
}
