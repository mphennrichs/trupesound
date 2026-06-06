import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_data_service.g.dart';

class StorageConfig {
  final String endpoint;
  final String accessKey;
  final String secretKey;

  const StorageConfig({
    required this.endpoint,
    required this.accessKey,
    required this.secretKey,
  });

  factory StorageConfig.fromJson(Map<String, dynamic> json) => StorageConfig(
    endpoint: json['endpoint'] as String,
    accessKey: json['accessKey'] as String,
    secretKey: json['secretKey'] as String,
  );
}

@Riverpod(keepAlive: true)
AppDataService appDataService(Ref ref) => AppDataService();

class AppDataService {
  static const _folderName = 'app_system_data';
  static const _storageConfigFileName = 'storage_config.json';

  Future<StorageConfig?> loadStorageConfig() async {
    if (kIsWeb) return null;

    final dir = await _getOrCreateDirectory();
    final file = File('${dir.path}/$_storageConfigFileName');
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    return StorageConfig.fromJson(jsonDecode(content) as Map<String, dynamic>);
  }

  Future<void> saveStorageConfig(StorageConfig config) async {
    if (kIsWeb) return;

    final dir = await _getOrCreateDirectory();
    final file = File('${dir.path}/$_storageConfigFileName');
    await file.writeAsString(
      jsonEncode({
        'endpoint': config.endpoint,
        'accessKey': config.accessKey,
        'secretKey': config.secretKey,
      }),
    );
  }

  Future<Directory> _getOrCreateDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDocDir.path}/$_folderName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
