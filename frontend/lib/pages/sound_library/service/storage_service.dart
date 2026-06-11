import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';

part 'storage_service.g.dart';

class StorageNotConfiguredException implements Exception {}

@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  return StorageService(ref.read(dioProvider));
}

class StorageService {
  final Dio _dio;

  StorageService(this._dio);

  Future<String> uploadSound({
    required String localFilePath,
    required String fileName,
    required void Function(double progress) onProgress,
  }) async {
    final presignResponse = await _dio.post<Map<String, dynamic>>(
      '/v1/app/storage/presign',
      data: {'fileName': fileName},
    );

    final uploadUrl = presignResponse.data!['uploadUrl'] as String;
    final objectUrl = presignResponse.data!['objectUrl'] as String;

    final file = File(localFilePath);
    final fileSize = await file.length();

    await Dio().put(
      uploadUrl,
      data: file.openRead(),
      options: Options(
        headers: {Headers.contentLengthHeader: fileSize},
      ),
      onSendProgress: (sent, total) {
        if (total > 0) onProgress(sent / total);
      },
    );

    return objectUrl;
  }
}
