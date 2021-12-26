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

  bool hasValueInstance(T value) {
    return this.firstWhere((e) => e == value, orElse: () => null) != null;
  }

  T findWhere(bool Function(T element) predicate) {
    return this.firstWhere((e) => predicate.call(e), orElse: () => null);
  }

  bool containsWhere(bool Function(T element) predicate) {
    return this.firstWhere((e) => predicate.call(e), orElse: () => null) != null;
  }

  Iterable<T> filterNotNull() {
    return this.where((e) => e != null);
  }

  Iterable<T> filterWhere(bool Function(T element) predicate) {
    return this.where((e) => predicate.call(e));
  }
}
