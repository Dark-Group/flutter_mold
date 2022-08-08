typedef GetterFunction<R> = R Function();

class Getter<T> {
  final GetterFunction<T?> _onGet;

  Getter(GetterFunction<T?> onGet) : this._onGet = onGet;

  T? get() => _onGet.call();

  T getRequired() => get()!;
}
