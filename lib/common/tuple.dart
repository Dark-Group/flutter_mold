class Tuple<T, R> {
  final T first;
  final R second;

  Tuple(this.first, this.second);
}

class Tuple3<F, S, T> extends Tuple<F, S> {
  final T third;

  Tuple3(F first, S second, this.third) : super(first, second);
}
