import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

const String _baseUrl = '/api';

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
      onRequest: (options, handler) {
        debugPrint('[HTTP] → ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('[HTTP] ← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint(
          '[HTTP] ✗ ${error.requestOptions.method} ${error.requestOptions.path} '
          '→ ${error.response?.statusCode ?? error.type} ${error.message}',
        );
        handler.next(error);
      },
    ),
  );

  return dio;
}
