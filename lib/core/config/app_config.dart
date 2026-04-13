import 'environment.dart';

class AppConfig {
  static const String _defaultInsforgeOssHost =
      'https://b6s4xvft.us-east.insforge.app';

  static const String insforgeOssHost = String.fromEnvironment(
    'INSFORGE_OSS_HOST',
    defaultValue: _defaultInsforgeOssHost,
  );

  static const String oauthRedirectUri = String.fromEnvironment(
    'INSFORGE_OAUTH_REDIRECT_URI',
    defaultValue: 'karateka.todo://auth/callback',
  );

  static bool get hasInsforgeHost =>
      Environment.projectHostOrNull != null || insforgeOssHost.trim().isNotEmpty;

  static String get insforgeBaseUrl {
    final fromEnvFile = Environment.projectHostOrNull;
    if (fromEnvFile != null) {
      return fromEnvFile;
    }

    final raw = insforgeOssHost.trim();
    if (raw.isEmpty) {
      throw const FormatException(
        'PROJECT_HOST/INSFORGE_OSS_HOST no está configurado.',
      );
    }

    return raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
  }
}
