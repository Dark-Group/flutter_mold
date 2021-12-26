class Setter<T> {
  T _value;

  Setter([T value]) {
    this._value = value;
  }

  set value(T newValue) {
    _value = newValue;
  }

  T get value => _value;
}
