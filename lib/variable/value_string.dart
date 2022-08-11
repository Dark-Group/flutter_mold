import 'package:flutter_mold/common/util.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/text_value.dart';

class ValueString extends TextValue {
  final int size;
  String _oldValue = "";
  String _value = "";
  final bool _mandatory;

  ValueString({required this.size, String value = "", bool mandatory = false}) : _mandatory = mandatory {
    _value = nvlString(value);
  }

  String getValue() => _value;

  void setValue(String? value) {
    _value = nvlString(value);
  }

  bool isEmpty() => getValue().isEmpty;

  bool nonEmpty() => !isEmpty();

  @override
  String getText() => getValue();

  @override
  void setText(String text) => setValue(text);

  @override
  void readyToChange() {
    _oldValue = _value;
  }

  @override
  bool mandatory() => _mandatory == true;

  @override
  bool modified() => _value != _oldValue;

  @override
  ErrorResult getError() {
    if (_value.length > size) {
      final errorMessage = "ValueString: Text length must not exceed $size characters";
      return ErrorResult.makeWithString(errorMessage);
    }

    if (mandatory() && isEmpty()) {
      return ErrorResult.makeWithString("ValueString: value is mandatory");
    }

    return ErrorResult.NONE;
  }
}
