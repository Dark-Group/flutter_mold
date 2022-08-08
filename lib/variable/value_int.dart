import 'package:flutter/foundation.dart';
import 'package:flutter_mold/log/logger.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/text_value.dart';
import 'package:flutter_mold/variable/value_string.dart';

class ValueInt extends ChangeNotifier implements TextValue {
  final ValueString _value;
  final bool _mandatory;

  ValueInt({required int size, String? text, int? number, bool mandatory = false}) //
      : this._value = ValueString(size: size, mandatory: false),
        this._mandatory = mandatory {
    if (text != null) {
      this.setText(text);
    }

    if (number != null) {
      this.setValue(number);
    }
  }

  int? getValue() {
    String r = this._value.getValue();
    if (r.isNotEmpty == true) {
      return int.tryParse(r);
    }
    return null;
  }

  bool isZero() {
    return 0 == getValue();
  }

  bool isZeroOrNull() {
    return getValue() == null || isZero();
  }

  void setValue(int? newValue) {
    if (newValue == null) {
      this._value.setValue(null);
    } else {
      this._value.setValue(newValue.toString());
    }
    notifyListeners();
  }

  bool isEmpty() => this._value.isEmpty();

  bool nonEmpty() => this._value.nonEmpty();

  @override
  String getText() => this._value.getText();

  @override
  void setText(String text) {
    this._value.setText(text);
    notifyListeners();
  }

  @override
  void readyToChange() {
    this._value.readyToChange();
  }

  @override
  bool mandatory() => this._mandatory;

  @override
  bool modified() => this._value.modified();

  @override
  ErrorResult getError() {
    ErrorResult r = this._value.getError();
    if (r.isError()) {
      return r;
    }

    try {
      String q = this._value.getValue();
      if (q.isNotEmpty == true) {
        int.parse(q);
      }
    } catch (ex, st) {
      Log.error(ex, st);
      return ErrorResult.makeWithException(ex as Exception);
    }

    if (this.mandatory() && this.isEmpty()) {
      return ErrorResult.makeWithString("ValueInt: value is mandatory");
    }

    return ErrorResult.NONE;
  }
}
