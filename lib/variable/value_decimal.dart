import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mold/common/logger.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/quantity.dart';
import 'package:flutter_mold/variable/text_value.dart';
import 'package:flutter_mold/variable/value_string.dart';

class ValueDecimal extends ChangeNotifier implements TextValue, Quantity {
  final int? precision;
  final int? scale;
  final ValueString _value;
  final bool _mandatory;

  Decimal? _cache;

  ValueDecimal({@required this.precision, @required this.scale, bool mandatory = false})
      : this._value = new ValueString(size: 200, mandatory: false),
        this._mandatory = mandatory;

  Decimal? getValue() {
    if (this._cache == null) {
      String s = this._value.getValue();
      if (s.isNotEmpty) {
        try {
          this._cache = new Decimal.parse(s);
        } catch (e, st) {
          Log.error(e, st);
        }
      }
    }
    return this._cache;
  }

  void setValue(Decimal? newValue) {
    this._cache = null;
    String v = "";
    if (newValue != null) {
      v = newValue.toString();
    }
    this._value.setValue(v);
    notifyListeners();
  }

  bool isEmpty() => _value.isEmpty();

  bool nonEmpty() => _value.nonEmpty();

  bool isZero() {
    if (isEmpty()) {
      return true;
    }
    Decimal? v = getValue();
    return v == null || v.compareTo(Decimal.zero) == 0;
  }

  bool nonZero() => !isZero();

  @override
  Decimal getQuantity() => this.getValue() ?? Decimal.zero;

  @override
  String getText() => this._value.getValue();

  @override
  void setText(String text) {
    this._cache = null;
    this._value.setText(text);
    notifyListeners();
  }

  @override
  void readyToChange() => this._value.readyToChange();

  @override
  bool mandatory() => this._mandatory;

  @override
  bool modified() => this._value.modified();

  @override
  ErrorResult getError() {
    Decimal? v = getValue();

    if (this._value.nonEmpty() && v == null) {
      String errorMessage = "ValueDecimal: The field must contain only numeric";
      return ErrorResult.makeWithString(errorMessage);
    }

    if (v != null &&
        ((this.precision != null && v.precision > this.precision!) ||
            (this.scale != null && v.scale > this.scale!))) {
      String errorMessage = "ValueDecimal: Incorrect format $precision,$scale";
      return ErrorResult.makeWithString(errorMessage);
    }

    if (this.mandatory() && this.isEmpty()) {
      return ErrorResult.makeWithString("ValueDecimal: value is mandatory");
    }

    return ErrorResult.NONE;
  }
}
