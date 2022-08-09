import 'package:flutter/material.dart';
import 'package:flutter_mold/common/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group("test addSafety function inside of BehaviorSubject", () {
    test("test add new item closed BehaviorSubject", () {
      BehaviorSubject<int> b = BehaviorSubject.seeded(1);
      expect(b.value, equals(1));
      b.close();
      b.addSafety(2);
      expect(b.value, equals(1));
    });

    test("test add new item  BehaviorSubject", () {
      BehaviorSubject<int> b = BehaviorSubject.seeded(1);
      expect(b.value, equals(1));
      b.addSafety(2);
      expect(b.value, equals(2));
      b.close();
    });
  });

  group("test ByteToTextSize extensions", () {
    test("test byByteSize", () {
      expect(12565.byByteSize, equals(12565));
    });

    test("test byByteSize", () {
      expect(12565.byKByteSize, equals(12));
    });

    test("test byMByteSize", () {
      expect(125632534255.byMByteSize, equals(119812));
    });

    test("test byGByteSize", () {
      expect(125632534255.byGByteSize, equals(117));
    });

    test("test toByteSize with gb data", () {
      expect(125632534255.toByteSize(), equals("117 gb"));
    });

    test("test toByteSize with mb data", () {
      expect(125632534.toByteSize(), equals("119 mb"));
    });

    test("test toByteSize with kb data", () {
      expect(12565.toByteSize(), equals("12 kb"));
    });

    test("test byByteSize bytes", () {
      expect(125.toByteSize(), equals("125 bytes"));
    });
  });

  group("test Iterables extensions", () {
    test("test groupBy function with empty list", () {
      expect(<String>[].groupBy<String>((e) => e), equals({}));
    });

    test("test groupBy function", () {
      expect(
          <String>["a", "b", "c", "a"].groupBy<String>((e) => e),
          equals({
            "a": ["a", "a"],
            "b": ["b"],
            "c": ["c"]
          }));
    });
  });

  group("test DoubleExtentions extensions", () {
    test("test takeIf function with  true predicate", () {
      expect(2.5.takeIf((e) => true), equals(2.5));
    });

    test("test takeIf function with false predicate", () {
      expect(2.5.takeIf((e) => false), isNull);
    });

    test("test takeUnless function with  true predicate", () {
      expect(2.5.takeUnless((e) => true), isNull);
    });

    test("test takeUnless function with false predicate", () {
      expect(2.5.takeUnless((e) => false), equals(2.5));
    });
  });

  group("test IntExtentions extensions", () {
    test("test takeIf function with  true predicate", () {
      expect(2.takeIf((e) => true), equals(2));
    });

    test("test takeIf function with false predicate", () {
      expect(2.takeIf((e) => false), isNull);
    });

    test("test takeUnless function with  true predicate", () {
      expect(2.takeUnless((e) => true), isNull);
    });

    test("test takeUnless function with false predicate", () {
      expect(2.takeUnless((e) => false), equals(2));
    });
  });

  group("test ObjectExtentions extensions", () {
    test("test takeIf function with  true predicate", () {
      final obj = Object();
      expect(obj.takeIf((e) => true), equals(obj));
    });

    test("test takeIf function with false predicate", () {
      expect(Object().takeIf((e) => false), isNull);
    });

    test("test takeUnless function with  true predicate", () {
      expect(Object().takeUnless((e) => true), isNull);
    });

    test("test takeUnless function with false predicate", () {
      final obj = Object();
      expect(obj.takeUnless((e) => false), equals(obj));
    });
  });

  group("test StringExtentions extensions", () {
    test("test takeIf function with  true predicate", () {
      expect("2".takeIf((e) => true), equals("2"));
    });

    test("test takeIf function with false predicate", () {
      expect("2".takeIf((e) => false), isNull);
    });

    test("test takeUnless function with  true predicate", () {
      expect("2".takeUnless((e) => true), isNull);
    });

    test("test takeUnless function with false predicate", () {
      expect("2".takeUnless((e) => false), equals("2"));
    });

    test("test fromHex function with empty String", () {
      expect(() => "".fromHex(), throwsA(isA()));
    });

    test("test fromHex function with incorrect String", () {
      expect(() => "234dfvxct3456".fromHex(), throwsA(isA()));
    });

    test("test fromHex function with 3 String", () {
      expect("FFF".fromHex(), Colors.white);
    });

    test("test fromHex function with 4 String", () {
      expect("#FFF".fromHex(), Colors.white);
    });

    test("test fromHex function with 6 String", () {
      expect("FFFFFF".fromHex(), Colors.white);
    });

    test("test fromHex function with 7 String", () {
      expect("#FFFFFF".fromHex(), Colors.white);
    });

    test("test toPhoneFormat function with empty String", () {
      expect("".toPhoneFormat(), "");
    });

    test("test toPhoneFormat function with +(998)89-598-98-98  String", () {
      expect("+(998)89-598-98-98".toPhoneFormat(), "+998895989898");
    });
  });

  group("test ListExtensions extensions", () {
    test("test mapNotNullTo function with empty list", () {
      expect(<String>[].mapNotNullTo<dynamic, List<dynamic>>(<dynamic>[], (e) => null), equals([]));
    });

    test("test mapNotNullTo function", () {
      final list = <String>[];
      <int>[1, 2, 3].mapNotNullTo<String, List<String>>(list, (intItem) => intItem.toString());
      expect(list, equals(["1", "2", "3"]));
    });

    test("test mapNotNullTo function with null object ", () {
      final list = <String>[];
      <int?>[1, 2, 3, null].mapNotNullTo<String, List<String>>(list, (intItem) => intItem?.toString());
      expect(list, equals(["1", "2", "3"]));
    });

    test("test mapNotNull function with empty list", () {
      expect(<String>[].mapNotNull<dynamic>((e) => null), equals([]));
    });

    test("test mapNotNull function", () {
      expect(<int>[1, 2, 3].mapNotNull<String>((intItem) => intItem.toString()), equals(["1", "2", "3"]));
    });

    test("test mapNotNull function with null object", () {
      expect(<int?>[1, 2, 3, null].mapNotNull<String>((intItem) => intItem?.toString()), equals(["1", "2", "3"]));
    });

    test("test mapList function with empty list", () {
      expect(<String>[].mapList<dynamic>((e) => null), equals([]));
    });

    test("test mapList function", () {
      expect(<int>[1, 2, 3].mapList<String>((intItem) => intItem.toString()), equals(["1", "2", "3"]));
    });

    test("test mapList function", () {
      expect(<int?>[1, 2, 3, null].mapList<String>((intItem) => intItem?.toString()), equals(["1", "2", "3", null]));
    });

    test("test whereNotNull function with empty list", () {
      expect(<String>[].whereNotNull((e) => false), equals([]));
    });

    test("test whereNotNull function with true predicate", () {
      expect([1, 2, 3].whereNotNull((intItem) => true), equals([1, 2, 3]));
    });

    test("test whereNotNull function with false predicate", () {
      expect([1, 2, 3].whereNotNull((intItem) => false), equals(<int>[]));
    });

    test("test whereNotNull function with predicate", () {
      expect([1, 2, 3].whereNotNull((intItem) => intItem % 2 == 0), equals(<int>[2]));
    });

    test("test whereNotNull function with true predicate and null item", () {
      expect([1, 2, 3, null].whereNotNull((intItem) => true), equals([1, 2, 3]));
    });

    test("test whereNotNull function with false predicate and null item", () {
      expect([1, 2, 3, null].whereNotNull((intItem) => false), equals(<int>[]));
    });

    test("test whereNotNull function with predicate  and null item", () {
      expect([1, 2, 3, null].whereNotNull((intItem) => intItem != null && intItem % 2 == 0), equals(<int>[2]));
    });

    test("test whereNot function with empty list", () {
      expect(<String>[].whereNot((e) => false), equals([]));
    });

    test("test whereNot function with true predicate", () {
      expect([1, 2, 3].whereNot((intItem) => true), equals(<int>[]));
    });

    test("test whereNot function with false predicate", () {
      expect([1, 2, 3].whereNot((intItem) => false), equals([1, 2, 3]));
    });

    test("test whereNot function with predicate", () {
      expect([1, 2, 3].whereNot((intItem) => intItem % 2 == 0), equals(<int>[1, 3]));
    });

    test("test whereNot function with predicate  and null item", () {
      expect(() => [1, 2, 3, null].whereNot((e) => e != null && e % 2 == 0), throwsA(isA()));
    });

    test("test firstWhereOrNull function with empty list and false predicate", () {
      expect(<String>[].firstWhereOrNull((e) => false), isNull);
    });

    test("test firstWhereOrNull function with empty list and true predicate", () {
      expect(<String>[].firstWhereOrNull((e) => true), isNull);
    });

    test("test firstWhereOrNull function with true predicate", () {
      expect([1, 2, 3].firstWhereOrNull((intItem) => true), equals(1));
    });

    test("test firstWhereOrNull function with false predicate", () {
      expect([1, 2, 3].firstWhereOrNull((intItem) => false), isNull);
    });

    test("test firstWhereOrNull function with predicate", () {
      expect([1, 2, 3, 4].firstWhereOrNull((intItem) => intItem % 2 == 0), equals(2));
    });

    test("test firstWhereOrNull function with predicate  and null item", () {
      expect(() => [null, 1, 2, 3].firstWhereOrNull((e) => e != null && e % 2 == 0), throwsA(isA()));
    });

    test("test lastWhereOrNull function with empty list and false predicate", () {
      expect(<String>[].lastWhereOrNull((e) => false), isNull);
    });

    test("test lastWhereOrNull function with empty list and true predicate", () {
      expect(<String>[].lastWhereOrNull((e) => true), isNull);
    });

    test("test lastWhereOrNull function with true predicate", () {
      expect([1, 2, 3].lastWhereOrNull((intItem) => true), equals(3));
    });

    test("test lastWhereOrNull function with false predicate", () {
      expect([1, 2, 3].lastWhereOrNull((intItem) => false), isNull);
    });

    test("test lastWhereOrNull function with predicate", () {
      expect([1, 2, 3, 4].lastWhereOrNull((intItem) => intItem % 2 == 0), equals(4));
    });

    test("test lastWhereOrNull function with predicate  and null item", () {
      expect([null, 1, 2, 3].lastWhereOrNull((e) => e != null && e % 2 == 0), equals(2));
    });

    test("test lastWhereOrNull function with predicate  and null item", () {
      expect(() => [1, 2, 3, null].lastWhereOrNull((e) => e != null && e % 2 == 0), throwsA(isA()));
    });
  });
}
