import 'package:flutter_mold/preferences/pref.dart';

class LocalizationPref {
  //------------------------------------------------------------------------------------------------

  static final String MODULE = "mold_localization";

  //------------------------------------------------------------------------------------------------

  static final String APP_LANGUAGE = "app_language";

  //------------------------------------------------------------------------------------------------

  static Future<String?> getLanguage() {
    return Pref.load(MODULE, APP_LANGUAGE);
  }

  static Future<bool> setLanguage(String langCode) {
    if (langCode.trim().isEmpty) {
      throw new Exception("lang code is empty LangCode[$langCode]");
    }
    return Pref.save(MODULE, APP_LANGUAGE, langCode);
  }
}
