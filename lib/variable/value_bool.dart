import 'package:flutter/material.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/text_value.dart';

class ValueBool extends ChangeNotifier implements TextValue {
  bool? _oldValue;
  bool _value = false;
  final bool? _mandatory;
  bool? _enable;

  ValueBool({
    bool value = false,
    bool mandatory = false,
    bool enable = true,
  })  : _mandatory = mandatory,
        _enable = enable == true {
    _value = value;
  }

  bool? getValue() => this._value;

  void setValue(bool newValue) {
    _value = newValue;
    notifyListeners();
  }

  @override
  String getText() => _value == true ? "1" : "0";

  @override
  void setText(String text) {
    _value = "1" == text;
    notifyListeners();
  }

  void setEnable(bool enable){
    _enable = enable;
    notifyListeners();
  }

  @override
  void readyToChange() {
    _oldValue = _value;
  }

  @override
  bool enable() => _enable == true;

  @override
  bool mandatory() => _mandatory == true;

  @override
  bool modified() => _oldValue != _value;

  @override
  ErrorResult getError() => ErrorResult.NONE;
}
