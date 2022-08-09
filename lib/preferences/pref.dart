import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  static Future<bool> save(String module, String code, String? value) async {
    final pref = await _pref;
    final key = "$module:$code";
    if (value == null) {
      if (pref.containsKey(key)) {
        return pref.remove(key);
      }
    } else {
      return pref.setString(key, value);
    }
    return false;
  }

  static Future<String?> load(String module, String code) async {
    final key = "$module:$code";
    return loadWithKey(key);
  }

  static Future<String?> loadWithKey(String key) async {
    final pref = await _pref;
    if (pref.containsKey(key)) {
      return pref.getString(key);
    }
    return null;
  }
}
