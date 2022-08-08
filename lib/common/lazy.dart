import 'package:flutter_mold/log/logger.dart';

typedef LazyLoad<T> = T Function();

class Lazy<T> {
  T? _data;
  bool _isLoaded = false;
  final LazyLoad<T>? _onLoadLazy;

  Lazy(LazyLoad<T>? onLoadLazy)
      : _onLoadLazy = onLoadLazy,
        _isLoaded = false;

  T? _load() {
    try {
      this._data = this._onLoadLazy?.call();
      return this._data;
    } catch (e, st) {
      Log.error("Error($e)\n$st");
      return null;
    } finally {
      this._isLoaded = true;
      Log.debug("Lazy.load($_data)");
    }
  }

  T? get() {
    if (this._isLoaded) {
      return this._data;
    }
    return this._load();
  }

  void reset() {
    this._data = null;
    this._isLoaded = false;
  }
}
