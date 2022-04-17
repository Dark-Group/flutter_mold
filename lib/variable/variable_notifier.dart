import 'package:flutter/cupertino.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable.dart';

class VariableNotifier<V extends Variable> extends ChangeNotifier implements Variable {
  Variable? _value;

  VariableNotifier({V? value}) : _value = value;

  void setValue(V? value) {
    _value = value;
    super.notifyListeners();
  }

  V? getValue() => _value as V;

  @override
  ErrorResult getError() => _value?.getError() ?? ErrorResult.NONE;

  @override
  bool mandatory() => _value?.mandatory() ?? false;

  @override
  bool modified() => _value?.modified() ?? false;

  @override
  void readyToChange() => _value?.readyToChange();
}
