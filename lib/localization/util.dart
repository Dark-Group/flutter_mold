import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_mold/common/tuple.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/log/logger.dart';

class AppLangUtil {
  static Future<Tuple<String, Map<String, String>>> loadSupportLang() async {
    const filePath = 'assets/l10n/support_langs.json';
    final jsonString = await rootBundle.loadString(filePath).catchError((e, st) {
      Log.error(e, st);
      return "{}";
    });

    Map<String, dynamic> data = json.decode(jsonString);
    final defaultLangCode = data.containsKey("default") ? data["default"] : "ru";
    data.remove("default");

    Map<String, String> languages = data.map((key, value) => MapEntry(
          key.toLowerCase().split("_").first.trim(),
          value.toString().trim(),
        ));

    languages.removeWhere((key, value) => value.isEmpty);

    if (languages.isEmpty) {
      languages["ru"] = "Русский";
    }

    return Tuple(defaultLangCode, languages);
  }

  static Future<Map<String, String>> loadLocalizations() async {
    final langCode = AppLang.getInstance().getLangCode();

    final result = <String, String>{};

    final localTranslates = AppLang.getInstance().onGetTranslate?.call(langCode);
    if (localTranslates != null && localTranslates.isNotEmpty) {
      localTranslates.removeWhere((k, _) => result.containsKey(k));
      result.addAll(localTranslates);
    }

    return result;
  }
}
