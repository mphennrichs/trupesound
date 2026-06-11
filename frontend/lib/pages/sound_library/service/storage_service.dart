import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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

  /// Upload [file] (must be picked with withData: true so bytes is populated).
  Future<String> uploadSound({
    required PlatformFile file,
    required void Function(double progress) onProgress,
  }) async {
    final bytes = file.bytes ?? Uint8List(0);

    final presignResponse = await _dio.post<Map<String, dynamic>>(
      '/v1/app/storage/presign',
      data: {'fileName': file.name},
    );

    final uploadUrl = presignResponse.data!['uploadUrl'] as String;
    final objectUrl = presignResponse.data!['objectUrl'] as String;

    await Dio().put(
      uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(headers: {Headers.contentLengthHeader: bytes.length}),
      onSendProgress: (sent, total) {
        if (total > 0) onProgress(sent / total);
      },
    );

    return objectUrl;
  }
}
