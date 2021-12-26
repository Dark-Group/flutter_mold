import 'package:flutter/material.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/text_value.dart';

class ValueBool extends ChangeNotifier implements TextValue {
  bool _oldValue;
  bool _value;
  final bool _mandatory;

  ValueBool({bool value = false, bool mandatory = false}) : this._mandatory = mandatory {
    this._value = value;
  }

  bool getValue() => this._value;

  void setValue(bool newValue) {
    this._value = newValue;
    notifyListeners();
  }

  @override
  String getText() => this._value ? "1" : "0";

  @override
  void setText(String text) {
    this._value = "1" == text;
    notifyListeners();
  }

  @override
  void readyToChange() {
    this._oldValue = this._value;
  }

  @override
  bool mandatory() => this._mandatory;

  @override
  bool modified() => this._oldValue != this._value;

  @override
  ErrorResult getError() => ErrorResult.NONE;
}
