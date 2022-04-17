import 'package:flutter/foundation.dart';
import 'package:flutter_mold/common/list_extension.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/text_value.dart';
import 'package:flutter_mold/variable/variable.dart';

class SpinnerOption extends Variable {
  // ignore: non_constant_identifier_names
  static SpinnerOption empty = SpinnerOption(code: "", name: "");

  static final notSelected = SpinnerOption(
    code: "#not_select#",
    name: "gwslib:spinner_option:not_selected".translate(),
    tag: null,
  );

  final String code;
  final String name;
  final Object? tag;

  SpinnerOption({
    required this.code,
    required this.name,
    this.tag,
  });

  int? getId() {
    if (code.isEmpty || code == notSelected.code) {
      return null;
    }
    return int.parse(code);
  }

  @override
  String toString() => name.toString();

  @override
  ErrorResult getError() => ErrorResult.NONE;

  @override
  bool mandatory() => false;

  @override
  bool modified() => false;

  @override
  void readyToChange() {}
}

class ValueSpinner extends ChangeNotifier implements TextValue {
  static void _checkValue(ValueSpinner spinner, [SpinnerOption? option]) {
    List<SpinnerOption> values = spinner._options;
    SpinnerOption value = option ?? spinner._value;

    values.checkUniqueness((e) => e.code);

    if (!values.hasValueInstance(value)) {
      throw Exception("ValueSpinner: value:$value instance is not found in spinner options");
    }
  }

  final List<SpinnerOption> _options;
  SpinnerOption? _oldValue;
  SpinnerOption _value;
  final bool _mandatory;

  ValueSpinner({
    required List<SpinnerOption> values,
    SpinnerOption? value,
    bool mandatory = false,
  })  : _options = values.map((e) => e).toList(),
        _mandatory = mandatory,
        _value = value ?? values[0] {
    _checkValue(this);
  }

  SpinnerOption getValue() => this._value;

  List<SpinnerOption> getOptions() => this._options;

  void setValue(SpinnerOption newValue) {
    _checkValue(this, newValue);
    this._value = newValue;
    notifyListeners();
  }

  void setOptions(List<SpinnerOption> options) {
    if (options.isEmpty) throw Exception("ValueSpinner: isEmpty");
    this._options.clear();
    this._options.addAll(options.map((e) => e).toList());
    setValue(options.firstWhere((e) => e.code == getValue().code, orElse: () => options.first));
  }

  int getPosition() => this._options.indexOf(this._value);

  bool isEmpty() => this._value.code.isEmpty;

  bool nonEmpty() => !isEmpty();

  @override
  String getText() => this._value.code;

  @override
  void setText(String text) {
    final found = this._options.firstWhere((e) => text == e.code);
    this.setValue(found);
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
  ErrorResult getError() {
    if (this.mandatory() && this.isEmpty()) {
      return ErrorResult.makeWithString("ValueSpinner: value is mandatory");
    }
    return ErrorResult.NONE;
  }
}
