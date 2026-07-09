import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trupe_sound/common/providers/dio_provider.dart';
import 'package:trupe_sound/pages/auth/models/user.dart';

part 'auth_service.g.dart';

@Riverpod()
AuthService authService(Ref ref) {
  return AuthService(ref.watch(dioProvider));
}

class AuthResult {
  final String accessToken;
  final AuthUser user;

  const AuthResult({required this.accessToken, required this.user});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        accessToken: json['accessToken'] as String,
        user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<AuthResult> login(String identifier, String password) async {
    final response = await _dio.post('/v1/auth/login', data: {
      'identifier': identifier,
      'password': password,
    });
    return AuthResult.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResult> register(
    String name,
    String username,
    String email,
    String password,
  ) async {
    final response = await _dio.post('/v1/auth/register', data: {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });
    return AuthResult.fromJson(response.data as Map<String, dynamic>);
  }
}
