import 'package:flutter_mold/variable/error_result.dart';

abstract class Variable {
  void readyToChange();

  bool enable();

  bool mandatory();

  bool modified();

  ErrorResult getError();
}
