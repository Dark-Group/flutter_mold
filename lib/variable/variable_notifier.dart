import 'package:flutter/cupertino.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable.dart';

class VariableNotifier<V extends Variable> extends ChangeNotifier implements Variable {
  Variable _value;

  VariableNotifier({V value}) : this._value = value;

  void setValue(V value) {
    this._value = value;
    super.notifyListeners();
  }

  V getValue() => this._value;

  @override
  ErrorResult getError() => this._value.getError();

  @override
  bool mandatory() => this._value.mandatory();

  @override
  bool modified() => this._value.modified();

  @override
  void readyToChange() => this._value.readyToChange();
}
