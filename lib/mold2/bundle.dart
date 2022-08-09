import 'package:flutter/widgets.dart';

class Bundle {
  static Bundle newBundle(BuildContext context, [Map<String, dynamic>? arguments]) {
    dynamic argument = ModalRoute.of(context)?.settings.arguments;
    Bundle? lastBundle;
    if (argument?.runtimeType == Bundle) {
      lastBundle = argument as Bundle;
    }

    final bundle = new Bundle._(lastBundle);
    if (arguments != null && arguments.isNotEmpty) {
      arguments.forEach((key, value) => bundle.put(key, value));
    }
    return bundle;
  }

  final Bundle? _lastBundle;
  final Map<String, dynamic> _bundle;

  Bundle._(Bundle? lastBundle)
      : this._lastBundle = lastBundle,
        this._bundle = <String, dynamic>{};

  Bundle put(String key, dynamic value) {
    this._bundle[key] = value;
    return this;
  }

  Bundle putString(String key, String value) => this.put(key, value);

  Bundle putInt(String key, int value) => this.put(key, value);

  Bundle putObject(String key, dynamic value) => this.put(key, value);

  dynamic get(String key) {
    if (this._bundle.containsKey(key)) {
      return this._bundle[key];
    }
    return this._lastBundle?.get(key) ?? null;
  }

  String? getString(String key) => get(key)?.toString();

  R? getObject<R>(String key) => (get(key) as R);

  int? getInt(String key) => get(key);
}
