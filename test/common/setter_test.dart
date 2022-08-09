import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mold/common/setter.dart';

void main() {
  test("test with initial value", () {
    Setter setter = new Setter();
    expect(setter.value, isNull);
  });

  test("test with dynamic type", () {
    Setter<dynamic> setter = new Setter(2);
    expect(setter.value, isNotNull);
    expect(setter.value.runtimeType, int);
  });

  test("test update value", () {
    Setter<int> setter = new Setter(2);
    expect(setter.value.runtimeType, int);
    expect(setter.value, equals(2));
    setter.value = 4;
    expect(setter.value, equals(4));
  });
}
