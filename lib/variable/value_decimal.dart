import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mold/log/logger.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/quantity.dart';
import 'package:flutter_mold/variable/text_value.dart';
import 'package:flutter_mold/variable/value_string.dart';

class ValueDecimal extends ChangeNotifier implements TextValue, Quantity {
  final int precision;
  final int scale;
  final ValueString _value;
  final bool? _mandatory;
  bool? _enable;

  Decimal? _cache;

  ValueDecimal({
    required this.precision,
    required this.scale,
    bool? mandatory = false,
    bool? enable = true,
  })  : _value = ValueString(size: 200, mandatory: false),
        _mandatory = mandatory,
        _enable = enable;

  Decimal? getValue() {
    if (_cache == null) {
      String s = _value.getValue();
      if (s.isNotEmpty == true) {
        try {
          _cache = Decimal.parse(s);
        } catch (e, st) {
          Log.error(e, st);
        }
      }
    }
    return _cache;
  }

  void setValue(Decimal? newValue) {
    _cache = null;
    String v = "";
    if (newValue != null) {
      v = newValue.toString();
    }
    _value.setValue(v);
    notifyListeners();
  }

  bool isEmpty() => _value.isEmpty();

  bool nonEmpty() => _value.nonEmpty();

  bool isZero() {
    if (isEmpty()) {
      return true;
    }
    final v = getValue();
    return v == null || v.compareTo(Decimal.zero) == 0;
  }

  bool nonZero() => !isZero();

  @override
  Decimal getQuantity() => getValue() ?? Decimal.zero;

  @override
  String getText() => _value.getValue();

  @override
  void setText(String text) {
    _cache = null;
    _value.setText(text);
    notifyListeners();
  }

  void setEnable(bool enable) {
    _enable = enable;
    notifyListeners();
  }

  @override
  void readyToChange() => _value.readyToChange();

  @override
  bool enable() => _enable == true;

  @override
  bool mandatory() => _mandatory ?? false;

  @override
  bool modified() => _value.modified();

  @override
  ErrorResult getError() {
    Decimal? v = getValue();

    if (_value.nonEmpty() && v == null) {
      String errorMessage = "ValueDecimal: The field must contain only numeric";
      return ErrorResult.makeWithString(errorMessage);
    }

    if (v != null && (v.precision > precision || v.scale > scale)) {
      String errorMessage = "ValueDecimal: Incorrect format $precision,$scale";
      return ErrorResult.makeWithString(errorMessage);
    }

    if (mandatory() && isEmpty()) {
      return ErrorResult.makeWithString("ValueDecimal: value is mandatory");
    }

    return ErrorResult.NONE;
  }
}
