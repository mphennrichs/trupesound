import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';

part 'storage_mode_provider.g.dart';

enum StorageMode { local, cloud, unknown }

@riverpod
Future<StorageMode> storageMode(Ref ref) async {
  try {
    final dio = ref.watch(dioProvider);
    final response = await dio.get<Map<String, dynamic>>('/v1/app/storage-mode');
    final mode = response.data?['mode'] as String?;
    return switch (mode) {
      'local' => StorageMode.local,
      'cloud' => StorageMode.cloud,
      _ => StorageMode.unknown,
    };
  } catch (_) {
    return StorageMode.unknown;
  }
}
