import 'dart:collection';

extension MyIterable<T, R> on Iterable<T> {
  void checkUniqueness(R Function(T element) onMap) {
    Set<R> keys = new HashSet();
    this.forEach((e) {
      R k = onMap.call(e);
      if (keys.contains(k)) {
        throw Exception("key:$k is duplicate");
      }
      keys.add(k);
    });
    keys.clear();
  }

  T? firstWhere(bool test(T element)) {
    for (T element in this) {
      if (test(element)) return element;
    }
    return null;
  }


  bool hasValueInstance(T value) {
    return firstWhere((e) => e == value) != null;
  }

  T? findWhere(bool Function(T element) predicate) {
    return firstWhere((e) => predicate.call(e));
  }

  bool containsWhere(bool Function(T element) predicate) {
    return firstWhere((e) => predicate.call(e)) != null;
  }

  Iterable<T> filterNotNull() => where((e) => e != null);

  Iterable<T> filterWhere(bool Function(T element) predicate) => where((e) => predicate.call(e));
}
