import 'package:flutter_mold/preferences/pref.dart';

class LocalizationPref {
  //------------------------------------------------------------------------------------------------

  static const String module = "mold_localization";

  //------------------------------------------------------------------------------------------------

  static const String appLanguage = "app_language";

  //------------------------------------------------------------------------------------------------

  static Future<String?> getLanguage() {
    return Pref.load(module, appLanguage);
  }

  static Future<bool> setLanguage(String langCode) {
    if (langCode.trim().isEmpty) {
      throw Exception("lang code is null or empty LangCode[$langCode]");
    }
    return Pref.save(module, appLanguage, langCode);
  }
}
