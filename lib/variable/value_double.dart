import 'package:flutter/foundation.dart';
import 'package:flutter_mold/log/logger.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/text_value.dart';
import 'package:flutter_mold/variable/value_string.dart';

class ValueDouble extends ChangeNotifier implements TextValue {
  final ValueString _value;
  final bool _mandatory;
  bool _enable;

  ValueDouble({required int size, String? text, double? number, bool mandatory = false, bool enable = true}) //
      : _value = ValueString(size: size, mandatory: false),
        _mandatory = mandatory,
        _enable = enable == true {
    if (text != null) {
      setText(text);
    }

    if (number != null) {
      setValue(number);
    }
  }

  double? getValue() {
    String r = _value.getValue();
    if (r.isNotEmpty == true) {
      return double.tryParse(r);
    }
    return null;
  }

  bool isZero() {
    return 0 == getValue();
  }

  bool isZeroOrNull() {
    return getValue() == null || isZero();
  }

  void setValue(double? newValue) {
    if (newValue == null) {
      _value.setValue(null);
    } else {
      _value.setValue(newValue.toString());
    }
    notifyListeners();
  }

  bool isEmpty() => _value.isEmpty();

  bool nonEmpty() => _value.nonEmpty();

  @override
  String getText() => _value.getText();

  @override
  void setText(String text) {
    _value.setText(text);
    notifyListeners();
  }

  void setEnable(bool enable) {
    _enable = enable;
    notifyListeners();
  }

  @override
  void readyToChange() {
    _value.readyToChange();
  }

  @override
  bool enable() => _enable == true;

  @override
  bool mandatory() => _mandatory;

  @override
  bool modified() => _value.modified();

  @override
  ErrorResult getError() {
    ErrorResult r = _value.getError();
    if (r.isError()) {
      return r;
    }

    try {
      String q = _value.getValue();
      if (q.isNotEmpty == true) {
        int.parse(q);
      }
    } catch (ex, st) {
      Log.error(ex, st);
      return ErrorResult.makeWithException(ex as Exception);
    }
    if (mandatory() && isEmpty()) {
      return ErrorResult.makeWithString("ValueDouble: value is mandatory");
    }

    return ErrorResult.NONE;
  }
}
