import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/system/service/storage_config_service.dart';

part 'storage_mode_provider.g.dart';

enum StorageMode { local, cloud, unknown }

@riverpod
Future<StorageMode> storageMode(Ref ref) async {
  try {
    final config = await ref.watch(storageConfigServiceProvider).load();
    if (config == null) return StorageMode.unknown;
    if (config.localFolder.isNotEmpty) return StorageMode.local;
    if (config.endpoint.isNotEmpty) return StorageMode.cloud;
    return StorageMode.unknown;
  } catch (_) {
    return StorageMode.unknown;
  }
}
