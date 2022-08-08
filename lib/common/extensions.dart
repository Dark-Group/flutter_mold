import 'dart:ui';

import 'package:flutter_mold/common/util.dart';
import 'package:rxdart/subjects.dart';

extension ExtendedBehaviorSubject<T> on BehaviorSubject<T> {
  addSafety(T obj) {
    if (!isClosed) {
      add(obj);
    }
  }
}

extension ByteToTextSize on int {
  int get byByteSize => this;

  int get byKByteSize => this ~/ 1024;

  int get byMByteSize => this / 1024 ~/ 1024;

  int get byGByteSize => this / 1024 / 1024 ~/ 1024;

  String toByteSize() {
    if (byByteSize < 1024) {
      return "$byByteSize bytes";
    } else if (byKByteSize < 1024) {
      return "$byKByteSize kb";
    } else if (byMByteSize < 1024) {
      return "$byMByteSize mb";
    }
    return "$byGByteSize gb";
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(<K, List<E>>{},
      (Map<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension BooleanLetExtention on bool {
  bool let(fun(bool it)) {
    fun(this);
    return this;
  }
}

extension DoubleExtentions on double {
  double let(fun(double it)) {
    fun(this);
    return this;
  }

  double? takeIf(bool predicate(double it)) {
    return predicate(this) == true ? this : null;
  }

  double? takeUnless(bool predicate(double it)) {
    return predicate(this) == false ? this : null;
  }
}

extension IntExtentions on int {
  int let(fun(int it)) {
    fun(this);
    return this;
  }

  int? takeIf(bool predicate(int it)) {
    return predicate(this) == true ? this : null;
  }

  int? takeUnless(bool predicate(int it)) {
    return predicate(this) == false ? this : null;
  }
}

extension ObjectExtentions on Object {
  T let<T>(fun(T it)) {
    fun(this as T);
    return this as T;
  }

  T? takeIf<T>(bool predicate(T it)) {
    return predicate(this as T) == true ? this as T : null;
  }

  T? takeUnless<T>(bool predicate(T it)) {
    return predicate(this as T) == false ? this as T : null;
  }

  void repeat(int times, action(int time)) {
    for (int i = 0; i < times; i++) {
      action(i);
    }
  }
}

extension StringExtentions on String {
  String let(fun(String it)) {
    fun(this);
    return this;
  }

  String? takeIf(bool predicate(String it)) {
    return predicate(this) == true ? this : null;
  }

  String? takeUnless(bool predicate(String it)) {
    return predicate(this) == false ? this : null;
  }

  Color fromHex() => Util.fromHex(this);

  String toPhoneFormat() {
    return this.replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "");
  }

  int toInt() => int.parse(this);

  int? toTryInt() => int.tryParse(this);

  double toDouble() => double.parse(this);

  double? toTryDouble() => double.tryParse(this);
}

extension ListExtensions<T> on Iterable<T> {
  List<R> mapNotNullTo<R, C extends List<R>>(C destination, R? transform(T)) {
    this.forEach((element) {
      transform.call(element)?.let((it) => (destination).add(it as R));
    });
    return destination;
  }

  List<R> mapNotNull<R>(R? transform(T)) {
    return this.mapNotNullTo<R, List<R>>(<R>[], transform);
  }

  List<K?> mapList<K>(K? Function(T element) transform) {
    return this.map(transform).toList();
  }

  Iterable<T> whereNotNull(bool test(T element)) => this.where((e) => e != null && test(e));

  Iterable<T> whereNot(bool test(T element)) => this.where((e) => !test(e));

  T? firstWhereOrNull(bool test(T element)) {
    final result = this.where(test);
    return result.isEmpty ? null : result.first;
  }

  T? lastWhereOrNull(bool test(T element)) {
    final result = this.where(test);
    return result.isEmpty ? null : result.last;
  }
}
