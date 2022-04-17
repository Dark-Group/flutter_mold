import 'package:flutter/material.dart';
import 'package:flutter_mold/common/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("test nvl", () {
    test("test dynamic type with null object", () {
      expect(nvl(null), isNull);
    });

    test("test dynamic type with not null object", () {
      expect(nvl(3).runtimeType, equals(int));
    });

    test("test null object with defaultValue ", () {
      expect(nvl(null, 3), equals(3));
    });
  });

  group("test nvlTryInt", () {
    test("test with null object", () {
      expect(nvlTryInt(null), isNull);
    });

    test("test with int object", () {
      expect(nvlTryInt(3), equals(3));
    });

    test("test with double object", () {
      expect(nvlTryInt(3.2), isNull);
    });

    test("test with String object", () {
      expect(nvlTryInt("3"), equals(3));
    });

    test("test with String incorrect object", () {
      expect(nvlTryInt("234sa&*^f3"), isNull);
    });
  });

  group("test nvlTryIntByZero", () {
    test("test with null object", () {
      expect(nvlTryIntByZero(null), isZero);
    });

    test("test with int object", () {
      expect(nvlTryIntByZero(3), equals(3));
    });

    test("test with double object", () {
      expect(nvlTryIntByZero(3.2), isZero);
    });

    test("test with String object", () {
      expect(nvlTryIntByZero("3"), equals(3));
    });

    test("test with String incorrect object", () {
      expect(nvlTryIntByZero("234sa&*^f3"), isZero);
    });
  });

  group("test nvlTryNumByZero", () {
    test("test with null object", () {
      expect(nvlTryNumByZero(null), isZero);
    });

    test("test with int object", () {
      expect(nvlTryNumByZero(3), equals(3));
    });

    test("test with num object", () {
      expect(nvlTryNumByZero(3.0), equals(3.0));
    });

    test("test with double object", () {
      expect(nvlTryNumByZero(3.2), equals(3.2));
    });

    test("test with String object", () {
      expect(nvlTryNumByZero("3"), equals(3));
    });

    test("test with String incorrect object", () {
      expect(nvlTryNumByZero("234sa&*^f3"), isZero);
    });
  });

  group("test nvlTryNum", () {
    test("test with null object", () {
      expect(nvlTryNum(null), isNull);
    });

    test("test with int object", () {
      expect(nvlTryNum(3), equals(3));
    });

    test("test with num object", () {
      expect(nvlTryNum(3.0), equals(3.0));
    });

    test("test with double object", () {
      expect(nvlTryNum(3.2), equals(3.2));
    });

    test("test with String object", () {
      expect(nvlTryNum("3"), equals(3));
    });

    test("test with String incorrect object", () {
      expect(nvlTryNum("234sa&*^f3"), isNull);
    });
  });

  group("test nvlTryDouble", () {
    test("test with null object", () {
      expect(nvlTryDouble(null), isNull);
    });

    test("test with double object", () {
      expect(nvlTryDouble(3.0), equals(3.0));
    });

    test("test with String object", () {
      expect(nvlTryDouble("3"), equals(3.0));
    });

    test("test with String incorrect object", () {
      expect(nvlTryDouble("234sa&*^f3"), isNull);
    });
  });

  group("test nvlInt", () {
    test("test with null object", () {
      expect(nvlInt(null), isZero);
    });

    test("test with not null object", () {
      expect(nvlInt(3), equals(3));
    });

    test("test with not null object for type", () {
      expect(nvlInt(3).runtimeType, equals(int));
    });

    test("test null object with defaultValue ", () {
      expect(nvlInt(null, 3), equals(3));
    });
  });

  group("test nvlString", () {
    test("test with null object", () {
      expect(nvlString(null), isEmpty);
    });

    test("test with not null object", () {
      expect(nvlString("3"), equals("3"));
    });

    test("test with not null object for type", () {
      expect(nvlString("3").runtimeType, equals(String));
    });

    test("test null object with defaultValue ", () {
      expect(nvlString(null, "3"), equals("3"));
    });
  });

  group("test nonEmpty", () {
    test("test with null", () {
      expect(Util.nonEmpty(null), isFalse);
    });

    test("test with empty String", () {
      expect(Util.nonEmpty(''), isFalse);
    });

    test("test with not empty String", () {
      expect(Util.nonEmpty('fdgj'), isTrue);
    });
  });

  group("test isEmpty", () {
    test("test with null", () {
      expect(Util.isEmpty(null), isTrue);
    });

    test("test with empty String", () {
      expect(Util.isEmpty(''), isTrue);
    });

    test("test with not empty String", () {
      expect(Util.isEmpty('fdgj'), isFalse);
    });
  });

  group("test fromHex", () {
    // test("test fromHex function with null object", () {
    //   expect(() => Util.fromHex(null), throwsA(isA()));
    // });

    test("test fromHex function with empty String", () {
      expect(() => Util.fromHex(""), throwsA(isA()));
    });

    test("test fromHex function with incorrect String", () {
      expect(() => Util.fromHex("234dfvxct3456"), throwsA(isA()));
    });

    test("test fromHex function with 3 String", () {
      expect(Util.fromHex("FFF"), Colors.white);
    });

    test("test fromHex function with 4 String", () {
      expect(Util.fromHex("#FFF"), Colors.white);
    });

    test("test fromHex function with 6 String", () {
      expect(Util.fromHex("FFFFFF"), Colors.white);
    });

    test("test fromHex function with 7 String", () {
      expect(Util.fromHex("#FFFFFF"), Colors.white);
    });
  });

  group("test get", () {
    test("test get function with default value", () {
      expect(Util.get(Map<String, dynamic>(), "key", defaultValue: "defaultValue"), "defaultValue");
    });

    // test("test get function with null key", () {
    //   expect(Util.get(Map<String, dynamic>(), null), isEmpty);
    // });

    test("test get function with null default key", () {
      expect(Util.get({"key1": 1, "key2": "value2"}, "key", defaultValue: null), isNull);
    });

    test("test get function with null data", () {
      expect(Util.get(null, "key", defaultValue: null), isNull);
    });

    test("test get function with valid key", () {
      expect(Util.get({"key": "9", "key1": "value1"}, "key", defaultValue: null), "9");
    });
  });

  group("test fazoGet", () {
    test("test fazoGet function with not available key", () {
      expect(Util.fazoGet(["ever", "never", "time"], [], "parametr"), isNull);
    });

    test("test fazoGet function with empty data", () {
      expect(Util.fazoGet(["ever", "never", "time"], [], "ever"), isNull);
    });

    test("test fazoGet function with null key", () {
      expect(Util.fazoGet(["ever", "never", "time"], ["ever", "time", "never"], null), isNull);
    });

    test("test fazoGet function with there is a key but there is no value", () {
      expect(Util.fazoGet(["ever", "never", "time"], ["ever", "never"], "time"), isNull);
    });

    test("test fazoGet function with empty data and p", () {
      expect(Util.fazoGet([], [], "ever"), isNull);
    });
    test("test fazoGet function with valid key", () {
      expect(Util.fazoGet(["ever", "never", "time"], ["time", "ever", "never"], "never"), "ever");
    });
  });
}
