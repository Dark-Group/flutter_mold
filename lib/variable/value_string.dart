import 'package:flutter/foundation.dart';
import 'package:flutter_mold/common/util.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/text_value.dart';

class ValueString extends ChangeNotifier implements TextValue {
  final int size;
  String _oldValue = "";
  String _value = "";
  final bool _mandatory;

  ValueString({required this.size, String value = "", bool mandatory = false}) : this._mandatory = mandatory {
    this._value = nvlString(value);
  }

  String getValue() => _value;

  void setValue(String? value) {
    this._value = nvlString(value);
    notifyListeners();
  }

  bool isEmpty() => getValue().isEmpty;

  bool nonEmpty() => !isEmpty();

  @override
  String getText() => getValue();

  @override
  void setText(String text) => setValue(text);

  @override
  void readyToChange() {
    this._oldValue = this._value;
  }

  @override
  bool mandatory() => this._mandatory;

  @override
  bool modified() => _value != _oldValue;

  @override
  ErrorResult getError() {
    if (this._value.length > size) {
      final errorMessage = "ValueString: Text length must not exceed $size characters";
      return ErrorResult.makeWithString(errorMessage);
    }

    if (this.mandatory() && this.isEmpty()) {
      return ErrorResult.makeWithString("ValueString: value is mandatory");
    }

    return ErrorResult.NONE;
  }
}
