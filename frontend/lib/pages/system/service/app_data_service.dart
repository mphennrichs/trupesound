import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'app_data_service.g.dart';

@Riverpod(keepAlive: true)
AppDataService appDataService(Ref ref) => AppDataService();

class AppDataService {
  static const _folderName = 'app_system_data';
  static const _fileName = 'app_data.json';

  Future<String> loadOrCreateAppId() async {
    final dir = await _getOrCreateDirectory();
    final file = File('${dir.path}/$_fileName');

    Map<String, dynamic> data = {};
    if (await file.exists()) {
      final content = await file.readAsString();
      data = jsonDecode(content) as Map<String, dynamic>;
    }

    final existing = data['appId'] as String?;
    if (existing == null || existing.isEmpty) {
      data['appId'] = const Uuid().v4();
      await file.writeAsString(jsonEncode(data));
    }

    return data['appId'] as String;
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
