import 'package:flutter_mold/common/list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("test checkUniqueness function", () {
    test("check with empty list", () {
      [].checkUniqueness((element) => element.toString());
    });

    test("check with unique items", () {
      [1, 2, 3, 5].checkUniqueness((element) => element.toString());
    });

    test("check with non unique items", () {
      expect(() => [1, 2, 3, 5, 2].checkUniqueness((e) => e.toString()), throwsA(isA()));
    });
  });

  group("test hasValueInstance function", () {
    test("check with empty list", () {
      expect([].hasValueInstance(null), isFalse);
    });

    test("search null object inside list", () {
      expect(<int?>[1, 32, 546].hasValueInstance(null), isFalse);
    });

    test("search null object inside contain null objects list ", () {
      expect([1, null, 546, null].hasValueInstance(null), isFalse);
    });
    test("search object inside list", () {
      expect([1, 32, 546].hasValueInstance(32), isTrue);
    });
  });

  group("test findWhere function", () {
    test("check with empty list", () {
      expect([].findWhere((element) => true), isNull);
    });

    test("check with unique items", () {
      expect([1, 2, 3, 5].findWhere((e) => e % 2 == 0), equals(2));
    });

    test("check with non unique items", () {
      expect([1, 2, 3, 5, 2].findWhere((e) => e == 9), isNull);
    });
  });

  group("test containsWhere function", () {
    test("check with empty list", () {
      expect([].containsWhere((e) => true), isFalse);
    });

    test("search null object inside list", () {
      expect([1, 32, 546].containsWhere((e) => e == null), isFalse);
    });

    test("search null object inside contain null objects list ", () {
      expect([1, null, 546, null].containsWhere((e) => e == null), isFalse);
    });

    test("search object inside list", () {
      expect([1, 32, 546].containsWhere((e) => e == 32), isTrue);
    });
  });

  group("test filterNotNull function", () {
    test("test empty list", () {
      expect([].filterNotNull(), isEmpty);
    });

    test("test list which all of them items are null", () {
      expect([null, null, null, null, null].filterNotNull(), isEmpty);
    });

    test("test list which all of them items are null and not null objects", () {
      expect([null, 2, null, 4, null].filterNotNull().length, equals(2));
    });
  });

  group("test filterWhere function", () {
    test("check with empty list", () {
      expect([].filterWhere((e) => true), isEmpty);
    });

    test("search null object inside list", () {
      expect([1, 32, 546].filterWhere((e) => e == null), isEmpty);
    });

    test("search null object inside contain null objects list ", () {
      expect([1, null, 546, null].filterWhere((e) => e == null), isNotEmpty);
    });

    test("search object inside list", () {
      expect([1, 32, 546].filterWhere((e) => e % 2 == 0), isNotEmpty);
    });
  });
}
