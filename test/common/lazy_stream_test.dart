import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mold/common/lazy_stream.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  test("test with dynamic type", () {
    LazyStream lazy = LazyStream(() => null);
    expect(lazy.get().runtimeType, equals(BehaviorSubject<dynamic>().runtimeType));
  });

  test("check type dynamic LazyStream when return int type", () {
    LazyStream lazy = LazyStream(() => 1);
    expect(lazy.get().runtimeType, equals(BehaviorSubject<dynamic>().runtimeType));
  });

  test("test dynamic LazyStream with null function", () {
    LazyStream lazy = LazyStream(null);
    expect(lazy.get().runtimeType, equals(BehaviorSubject<dynamic>().runtimeType));
  });

  test("check int type LazyStream when return int type", () {
    LazyStream<int> lazy = LazyStream(() => 1);
    expect(lazy.get().runtimeType, equals(BehaviorSubject<int>().runtimeType));
  });

  test("check LazyStream's add function", () {
    LazyStream<int> lazy = LazyStream(() => 1);
    expect(lazy.get().runtimeType, equals(BehaviorSubject<int>().runtimeType));
    expect(lazy.value, equals(1));
    lazy.add(2);
    expect(lazy.value, equals(2));
  });

  test("check LazyStream's add function with null initFunction", () {
    LazyStream<int> lazy = LazyStream(null);
    expect(lazy.get().runtimeType, equals(BehaviorSubject<int>().runtimeType));
    expect(lazy.value, isNull);
    lazy.add(2);
    expect(lazy.value, equals(2));
  });

  test("check LazyStream's close function ", () {
    LazyStream<int> lazy = LazyStream(null);
    expect(lazy.get().runtimeType, equals(BehaviorSubject<int>().runtimeType));
    expect(lazy.value, isNull);

    BehaviorSubject<int> oldSubject = lazy.get();
    expect(oldSubject, equals(lazy.get()));

    lazy.close();
    BehaviorSubject<int> newSubject = lazy.get();
    expect(newSubject, isNot(equals(oldSubject)));
  });
}
