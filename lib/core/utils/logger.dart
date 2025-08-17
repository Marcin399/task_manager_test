import 'package:flutter/foundation.dart';

class Logger {
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('🔍 DEBUG$tagPrefix [$timestamp]: $message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('ℹ️ INFO$tagPrefix [$timestamp]: $message');
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('⚠️ WARNING$tagPrefix [$timestamp]: $message');
    }
  }

  static void error(String message, {Object? error, String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('❌ ERROR$tagPrefix [$timestamp]: $message');
      if (error != null) {
        print('❌ ERROR$tagPrefix [$timestamp]: Error details: $error');
      }
    }
  }

  static void verbose(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagPrefix = tag != null ? '[$tag]' : '';
      print('📝 VERBOSE$tagPrefix [$timestamp]: $message');
    }
  }
}

void debugLog(String message, {String? tag}) {
  Logger.debug(message, tag: tag);
}

void infoLog(String message, {String? tag}) {
  Logger.info(message, tag: tag);
}

void warningLog(String message, {String? tag}) {
  Logger.warning(message, tag: tag);
}

void errorLog(String message, {Object? error, String? tag}) {
  Logger.error(message, error: error, tag: tag);
}
