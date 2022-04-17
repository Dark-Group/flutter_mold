import 'package:flutter_mold/common/lazy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("test with dynamic type", () {
    Lazy lazy = Lazy(() => null);
    expect(lazy.get(), isNull);
  });

  test("check type dynamic lazy when return int type", () {
    Lazy lazy = Lazy(() => 1);
    expect(lazy.get().runtimeType, int);
  });

  test("test dynamic lazy with null function", () {
    Lazy lazy = Lazy(null);
    expect(lazy.get(), isNull);
  });

  test("test String lazy", () {
    Lazy<String> lazy = Lazy(() => 2.toString());
    expect(lazy.get(), "2");
  });

  test("test lazy call function ", () {
    int callFunctionCounter = 0;
    LazyLoad<String> function = () {
      callFunctionCounter = callFunctionCounter + 1;
      return "2";
    };
    Lazy<String> lazy = Lazy(function);
    expect(lazy.get(), "2");
    lazy.get();
    lazy.get();
    expect(callFunctionCounter, 1);
  });

  test("test lazy call function with reset function ", () {
    int callFunctionCounter = 0;
    LazyLoad<String> function = () {
      callFunctionCounter = callFunctionCounter + 1;
      return "2";
    };
    Lazy<String> lazy = Lazy(function);
    expect(lazy.get(), "2"); //callFunctionCounter=1
    lazy.get();
    lazy.get();
    lazy.reset(); //callFunctionCounter=2
    lazy.get();
    lazy.get();
    expect(callFunctionCounter, 2);
  });
}
