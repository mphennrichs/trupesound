import 'dart:io';
import 'dart:typed_data';

import 'package:minio/minio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/pages/system/provider/system_info_provider.dart';
import 'package:trupe_sound/pages/system/service/storage_config_service.dart';

part 'storage_service.g.dart';

class StorageNotConfiguredException implements Exception {}

class _StorageConfig {
  final String endpoint;
  final String accessKey;
  final String secretKey;
  const _StorageConfig({required this.endpoint, required this.accessKey, required this.secretKey});
}

@Riverpod(keepAlive: true)
Future<StorageService> storageService(Ref ref) async {
  final appId = await ref.read(applicationIdProvider.future);
  final config = await ref.read(storageConfigServiceProvider).load();
  if (config == null) throw StorageNotConfiguredException();

  final service = StorageService(
    appId: appId,
    config: _StorageConfig(endpoint: config.endpoint, accessKey: config.accessKey, secretKey: ''),
  );
  await service.initialize();
  return service;
}

class StorageService {
  static const _soundsPrefix = 'sounds';

  final String _appId;
  final _StorageConfig _config;
  late final Minio _client;

  StorageService({required String appId, required _StorageConfig config})
    : _appId = appId,
      _config = config {
    _client = Minio(
      endPoint: config.endpoint,
      accessKey: config.accessKey,
      secretKey: config.secretKey,
    );
  }

  Future<void> initialize() async {
    final exists = await _client.bucketExists(_appId);
    if (!exists) {
      await _client.makeBucket(_appId);
    }
  }

  Future<String> uploadSound({
    required String localFilePath,
    required String fileName,
    required void Function(double progress) onProgress,
  }) async {
    final file = File(localFilePath);
    final fileSize = await file.length();
    final objectName = '$_soundsPrefix/$fileName';

    await _client.putObject(
      _appId,
      objectName,
      file.openRead().cast<Uint8List>(),
      size: fileSize,
      onProgress: (bytes) => onProgress(bytes / fileSize),
    );

    return 'http://${_config.endpoint}/$_appId/$objectName';
  }
}
