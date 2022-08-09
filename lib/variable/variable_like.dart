

import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable.dart';
import 'package:flutter_mold/variable/variable_util.dart';

abstract class VariableLike implements Variable {
  List<Variable> gatherVariables();

  @override
  void readyToChange() => VariableUtil.readyToChange(gatherVariables());

  @override
  bool modified() => VariableUtil.modified(gatherVariables());

  @override
  bool mandatory() => VariableUtil.mandatory(gatherVariables());

  @override
  ErrorResult getError() => VariableUtil.getError(gatherVariables());
}
