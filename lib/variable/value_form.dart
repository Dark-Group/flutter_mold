import 'package:flutter/foundation.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable_like.dart';
import 'package:flutter_mold/variable/variable_util.dart';

abstract class ValueForm extends ChangeNotifier implements VariableLike {
  final String code;
  final Object tag;
  final bool _mandatory;
  bool _enable;

  ValueForm({@required this.code, this.tag, bool mandatory = false}) : this._mandatory = mandatory;

  bool hasValue();

  bool isEnable() => this._enable == true;

  void setEnable(bool enable) {
    this._enable = enable;
  }

  @override
  void readyToChange() => VariableUtil.readyToChange(gatherVariables());

  @override
  bool modified() => VariableUtil.modified(gatherVariables());

  @override
  ErrorResult getError() => VariableUtil.getError(gatherVariables());

  @override
  bool mandatory() => this._mandatory;
}
