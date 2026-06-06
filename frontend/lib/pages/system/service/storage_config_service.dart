import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';

part 'storage_config_service.g.dart';

class StorageConfigData {
  final String endpoint;
  final String accessKey;
  final String localFolder;

  const StorageConfigData({
    required this.endpoint,
    required this.accessKey,
    this.localFolder = '',
  });
}

@Riverpod(keepAlive: true)
StorageConfigService storageConfigService(Ref ref) {
  return StorageConfigService(ref.read(dioProvider));
}

class StorageConfigService {
  final Dio _dio;

  StorageConfigService(this._dio);

  Future<StorageConfigData?> load() async {
    final response = await _dio.get('/v1/app/storage-config');
    final data = response.data as Map<String, dynamic>?;
    if (data == null || (data['endpoint'] as String?)?.isEmpty != false) {
      return null;
    }
    return StorageConfigData(
      endpoint: data['endpoint'] as String,
      accessKey: data['accessKey'] as String,
      localFolder: (data['localFolder'] as String?) ?? '',
    );
  }

  Future<void> save({
    required String endpoint,
    required String accessKey,
    required String secretKey,
    required String localFolder,
  }) async {
    await _dio.put('/v1/app/storage-config', data: {
      'endpoint': endpoint,
      'accessKey': accessKey,
      'secretKey': secretKey,
      'localFolder': localFolder,
    });
  }
}
