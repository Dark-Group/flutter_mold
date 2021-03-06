import 'package:rxdart/rxdart.dart';

typedef OnInitStream<E> = E Function();

class LazyStream<E> {
  OnInitStream<E> _onInitStream;

  LazyStream([OnInitStream<E> onInitStream]) {
    this._onInitStream = onInitStream ?? () => null;
  }

  BehaviorSubject<E> _element;
  E _lastAddSeedValue;

  BehaviorSubject<E> get() {
    if (_element == null) {
      final seedValue = _onInitStream.call();
      _element = BehaviorSubject.seeded(seedValue);
      this._lastAddSeedValue = seedValue;
    }
    return _element;
  }

  void add(E element) {
    this._lastAddSeedValue = element;
    get().sink.add(element);
  }

  Stream<E> get stream => get().stream;

  E get value => get().value;
  
  E get lastSeedValue => this._lastAddSeedValue;

  void close() {
    get().close();
    _element = null;
    _lastAddSeedValue = null;
  }
}
