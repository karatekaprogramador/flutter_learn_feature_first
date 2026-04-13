import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static const String _envFileName = '.env';
  static bool _isLoaded = false;

  static Future<void> load() async {
    if (_isLoaded) {
      return;
    }

    try {
      await dotenv.load(fileName: _envFileName);
    } catch (_) {}

    _isLoaded = true;
  }

  static String? get projectHostOrNull {
    final fromDotEnv = dotenv.env['PROJECT_HOST']?.trim() ?? '';
    if (fromDotEnv.isNotEmpty) {
      return _normalizeBaseUrl(fromDotEnv);
    }

    const fromDefine = String.fromEnvironment('PROJECT_HOST', defaultValue: '');
    if (fromDefine.trim().isNotEmpty) {
      return _normalizeBaseUrl(fromDefine);
    }

    return null;
  }

  static String get projectHost {
    final value = projectHostOrNull;
    if (value == null) {
      throw const FormatException(
        'PROJECT_HOST no está configurado en .env ni en --dart-define.',
      );
    }

    return value;
  }

  static String _normalizeBaseUrl(String value) {
    final normalized = value.trim();
    return normalized.endsWith('/')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
  }
}
