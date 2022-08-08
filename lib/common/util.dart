import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';

E nvl<E>(E? value, E defaultValue) {
  return value == null ? defaultValue : value;
}

/// nvlTryInt function
int? nvlTryInt(Object value) {
  if (value is String)
    return value.isNotEmpty == true ? int.tryParse(value) : null;
  else if (value is int)
    return value;
  else
    return null;
}

/// nvlTryInt function
int nvlTryIntByZero(Object value) {
  if (value is String)
    return value.isNotEmpty == true ? int.tryParse(value) ?? 0 : 0;
  else if (value is int)
    return value;
  else
    return 0;
}

/// nvlTryInt function
num nvlTryNumByZero(Object value) {
  if (value is String)
    return value.isNotEmpty == true ? num.tryParse(value) ?? 0 : 0;
  else if (value is num)
    return value;
  else if (value is int)
    return value;
  else if (value is double)
    return value;
  else
    return 0;
}

/// nvlTryNum function
num? nvlTryNum(Object value) {
  if (value is String)
    return value.isNotEmpty == true ? num.tryParse(value) : null;
  else if (value is num)
    return value;
  else if (value is int)
    return value;
  else if (value is double)
    return value;
  else
    return null;
}

double? nvlTryDouble(Object value) {
  if (value is String)
    return value.isNotEmpty == true ? double.tryParse(value) : null;
  else if (value is double)
    return value;
  else
    return null;
}

int nvlInt(int? value, [int defaultValue = 0]) {
  return value == null ? defaultValue : value;
}

String nvlString(String? value, [String? defaultValue]) {
  return value == null ? defaultValue ?? "" : value;
}

String calcSha256(String text) {
  final data = utf8.encode(text);
  return sha256.convert(data).toString().toLowerCase();
}

class Util {
  static dynamic get(Map<String, dynamic>? data, String key, {dynamic defaultValue}) {
    final result = data != null && data.containsKey(key) == true ? data[key] : defaultValue;
    if (result == null) {
      return defaultValue;
    }
    return result;
  }

  static String getString(Map<String, dynamic> data, String key, {String? defaultValue}) {
    return get(data, key, defaultValue: defaultValue);
  }

  static int getInt(Map<String, dynamic> data, String key, {int? defaultValue}) {
    return get(data, key, defaultValue: defaultValue);
  }

  static String? fazoGet(List<String> p, List<dynamic> data, String key) {
    if (data.isEmpty || p.isEmpty || key.isEmpty) return null;
    final int index = p.indexOf(key);
    if (index < 0) return null;
    if (data.length - 1 < index) return null;
    return data[index];
  }

  static bool nonEmpty(String? value) => !isEmpty(value);

  static bool isEmpty(String? value) => value == null || value.length == 0;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 4) {
      hexString =
          hexString[0] + hexString[1] + hexString[1] + hexString[2] + hexString[2] + hexString[3] + hexString[3];
    } else if (hexString.length == 3) {
      hexString = hexString[0] + hexString[0] + hexString[1] + hexString[1] + hexString[2] + hexString[2];
    }

    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
