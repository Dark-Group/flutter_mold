import 'package:flutter/widgets.dart';

class Bundle {
  static Bundle newBundle(BuildContext context, [Map<String, dynamic>? arguments]) {
    final bundle = new Bundle._();
    if (arguments != null && arguments.isNotEmpty) {
      arguments.forEach((key, value) => bundle.put(key, value));
    }
    return bundle;
  }

  final Map<String, dynamic> _bundle;

  Bundle._() : _bundle = <String, dynamic>{};

  Bundle put(String key, dynamic value) {
    _bundle[key] = value;
    return this;
  }

  Bundle putString(String key, String value) => this.put(key, value);

  Bundle putInt(String key, int value) => this.put(key, value);

  Bundle putObject(String key, dynamic value) => this.put(key, value);

  dynamic get(String key) {
    if (_bundle.containsKey(key)) {
      return _bundle[key];
    }
    return null;
  }

  String? getString(String key) => get(key)?.toString();

  R? getObject<R>(String key) => (get(key) as R);

  int? getInt(String key) => get(key);

  Map<String, String> getData() {
    Map<String, String> result = {};

    var bundleData = _bundle.map((key, value) => MapEntry(key, value.toString()));
    result.addAll(bundleData);

    return result;
  }
}
