import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_learn_feature_first/core/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

enum AuthOAuthProvider { google, github }

extension AuthOAuthProviderX on AuthOAuthProvider {
  String get key {
    switch (this) {
      case AuthOAuthProvider.google:
        return 'google';
      case AuthOAuthProvider.github:
        return 'github';
    }
  }

  String get label {
    switch (this) {
      case AuthOAuthProvider.google:
        return 'Google';
      case AuthOAuthProvider.github:
        return 'GitHub';
    }
  }
}

class AuthResult {
  final bool requireEmailVerification;
  final String message;
  final String? accessToken;
  final String? refreshToken;

  const AuthResult({
    required this.requireEmailVerification,
    required this.message,
    this.accessToken,
    this.refreshToken,
  });
}

class AuthApiException implements Exception {
  final String message;

  const AuthApiException(this.message);

  @override
  String toString() => message;
}

class InsforgeAuthService {
  final Dio _dio;

  InsforgeAuthService({required Dio dio}) : _dio = dio;

  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    final response = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '$_baseUrl/api/auth/users',
        queryParameters: const {'client_type': 'mobile'},
        data: {
          'email': email,
          'password': password,
          if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        },
      ),
    );

    return _parseAuthResult(
      response,
      successMessage: 'Registro realizado correctamente.',
    );
  }

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '$_baseUrl/api/auth/sessions',
        queryParameters: const {'client_type': 'mobile'},
        data: {
          'email': email,
          'password': password,
        },
      ),
    );

    return _parseAuthResult(
      response,
      successMessage: 'Sesión iniciada correctamente.',
    );
  }

  Future<void> startOAuth(AuthOAuthProvider provider) async {
    final pkce = _generatePkce();

    final response = await _request(
      () => _dio.get<Map<String, dynamic>>(
        '$_baseUrl/api/auth/oauth/${provider.key}',
        queryParameters: {
          'redirect_uri': AppConfig.oauthRedirectUri,
          'code_challenge': pkce.codeChallenge,
        },
      ),
    );

    final payload = response.data ?? <String, dynamic>{};
    final authUrl = payload['authUrl'] as String?;

    if (authUrl == null || authUrl.isEmpty) {
      throw const AuthApiException('No se pudo iniciar OAuth en InsForge.');
    }

    final launched = await launchUrl(
      Uri.parse(authUrl),
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw AuthApiException('No se pudo abrir ${provider.label}.');
    }
  }

  String get _baseUrl {
    try {
      return AppConfig.insforgeBaseUrl;
    } on FormatException {
      throw const AuthApiException(
        'Falta INSFORGE_OSS_HOST en la configuración.',
      );
    }
  }

  AuthResult _parseAuthResult(
    Response<Map<String, dynamic>> response, {
    required String successMessage,
  }) {
    final payload = response.data ?? <String, dynamic>{};

    final requireEmailVerification =
        payload['requireEmailVerification'] as bool? ?? false;

    return AuthResult(
      requireEmailVerification: requireEmailVerification,
      message: requireEmailVerification
          ? 'Revisa tu correo para verificar tu cuenta antes de iniciar sesión.'
          : successMessage,
      accessToken: payload['accessToken'] as String?,
      refreshToken: payload['refreshToken'] as String?,
    );
  }

  Future<Response<Map<String, dynamic>>> _request(
    Future<Response<Map<String, dynamic>>> Function() action,
  ) async {
    try {
      final response = await action();
      return response;
    } on DioException catch (e) {
      throw _toAuthApiException(e);
    }
  }

  AuthApiException _toAuthApiException(DioException exception) {
    final response = exception.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      final error = data['error'] as String?;
      return AuthApiException(message ?? error ?? 'Error de autenticación.');
    }

    return AuthApiException(
      'Error de autenticación (${statusCode ?? 'sin código'}).',
    );
  }

  _PkcePair _generatePkce() {
    final random = Random.secure();
    const charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

    final codeVerifier = List.generate(
      64,
      (_) => charset[random.nextInt(charset.length)],
    ).join();

    final digest = sha256.convert(utf8.encode(codeVerifier));
    final codeChallenge = _base64UrlNoPadding(digest.bytes);

    return _PkcePair(
      codeVerifier: codeVerifier,
      codeChallenge: codeChallenge,
    );
  }

  String _base64UrlNoPadding(List<int> input) {
    return base64UrlEncode(input).replaceAll('=', '');
  }
}

class _PkcePair {
  final String codeVerifier;
  final String codeChallenge;

  const _PkcePair({
    required this.codeVerifier,
    required this.codeChallenge,
  });
}
