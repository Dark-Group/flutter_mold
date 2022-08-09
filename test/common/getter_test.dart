import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mold/common/getter.dart';

void main() {
  test("test with null object", () {
    Getter<String> testGetter = Getter(() => null);
    expect(testGetter.get(), isNull);
  });

  test("test with correct object", () {
    Getter<String> testGetter = Getter(() => "salom");
    expect(testGetter.get(), equals("salom"));
  });
}
