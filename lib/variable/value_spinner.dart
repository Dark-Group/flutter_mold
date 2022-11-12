import 'package:flutter/foundation.dart';
import 'package:flutter_mold/common/extensions.dart';
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

  SpinnerOption({required this.code, required this.name, this.tag});

  int? getId() {
    if (code.isEmpty || code == notSelected.code) {
      return null;
    }
    return int.parse(code);
  }

  @override
  String toString() => this.name.toString();

  @override
  ErrorResult getError() => ErrorResult.NONE;

  @override
  bool enable() => true;

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
  bool _enable;

  ValueSpinner({
    required List<SpinnerOption> values,
    SpinnerOption? value,
    bool mandatory = false,
    bool enable = true,
  })  : _options = values.map((e) => e).toList(),
        _mandatory = mandatory,
        _enable = enable == true,
        _value = value ?? values[0] {
    _checkValue(this);
  }

  SpinnerOption getValue() => _value;

  List<SpinnerOption> getOptions() => _options;

  void setValue(SpinnerOption newValue) {
    _checkValue(this, newValue);
    _value = newValue;
    notifyListeners();
  }

  void setOptions(List<SpinnerOption> options) {
    if (options.isEmpty) throw Exception("ValueSpinner: isEmpty");
    _options.clear();
    _options.addAll(options.map((e) => e).toList());
    setValue(options.firstWhereOrNull((e) => e.code == getValue().code) ?? options.first);
  }

  int getPosition() => _options.indexOf(_value);

  bool isEmpty() => _value.code.isEmpty;

  bool nonEmpty() => !isEmpty();

  @override
  String getText() => _value.code;

  @override
  void setText(String text) {
    final found = _options.firstWhere((e) => text == e.code);
    setValue(found);
  }

  void setEnable(bool enable) {
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
  bool mandatory() => _mandatory;

  @override
  bool modified() => _oldValue != _value;

  @override
  ErrorResult getError() {
    if (mandatory() && isEmpty()) {
      return ErrorResult.makeWithString("ValueSpinner: value is mandatory");
    }
    return ErrorResult.NONE;
  }
}
