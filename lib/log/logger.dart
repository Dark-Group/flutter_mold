import 'package:flutter/foundation.dart';

class Log {
  static bool _logEnable = !kReleaseMode;

  static void init(bool logEnable) {
    Log._logEnable = logEnable;
  }

  static String _genMessage(String mode, String message) {
    return "Log.$mode: $message";
  }

  static void debug(String message) {
    if (_logEnable) {
      try {
        print(_genMessage("DEBUG", message));
      } catch (_) {
        print('Log(show log error)');
      }
    }
  }

  static void error([dynamic error, dynamic stacktrace]) {
    if (_logEnable) {
      String message = error.toString();
      if (stacktrace != null) {
        message += "\n$stacktrace";
      }
      try {
        print(_genMessage("ERROR", message));
      } catch (_) {
        print('Log(show log error)');
      }
    }
  }
}
