class Setter<T> {
  T? value;

  Setter([T? value]) {
    this.value = value;
  }

  T get valueRequired => value!;
}
