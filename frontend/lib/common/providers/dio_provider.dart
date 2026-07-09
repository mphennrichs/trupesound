import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/auth_storage_provider.dart';

part 'dio_provider.g.dart';

const String _baseUrl = String.fromEnvironment('API_URL', defaultValue: '/api');

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await ref.read(authStorageProvider.future);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        debugPrint('[HTTP] → ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('[HTTP] ← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) async {
        debugPrint(
          '[HTTP] ✗ ${error.requestOptions.method} ${error.requestOptions.path} '
          '→ ${error.response?.statusCode ?? error.type} ${error.message}',
        );
        if (error.response?.statusCode == 401) {
          await ref.read(authStorageProvider.notifier).clearToken();
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}
