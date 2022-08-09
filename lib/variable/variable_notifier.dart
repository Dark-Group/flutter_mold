import 'package:flutter/cupertino.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable.dart';

class VariableNotifier<V extends Variable> extends ChangeNotifier implements Variable {
  Variable? _value;

  VariableNotifier({V? value}) : this._value = value;

  void setValue(V value) {
    this._value = value;
    super.notifyListeners();
  }

  V? getValue() => this._value as V;

  @override
  ErrorResult getError() => this._value?.getError() ?? ErrorResult.NONE;

  @override
  bool mandatory() => this._value?.mandatory() == true;

  @override
  bool modified() => this._value?.modified() == true;

  @override
  void readyToChange() => this._value?.readyToChange();
}
