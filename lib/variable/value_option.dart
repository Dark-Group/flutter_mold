import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/value_bool.dart';
import 'package:flutter_mold/variable/variable.dart';
import 'package:flutter_mold/variable/variable_like.dart';

class ValueOption<T extends Variable> extends VariableLike {
  final String title;
  final ValueBool checked = ValueBool();
  final T? valueIfChecked;
  final dynamic tag;
  final bool _mandatory;
  bool _enable;

  ValueOption({
    required this.title,
    required this.valueIfChecked,
    this.tag,
    bool mandatory = false,
    bool enable = true,
  })  : _mandatory = mandatory,
        _enable = enable == true {
    if (valueIfChecked == null) {
      throw Exception("value  if checked is null");
    }
  }

  T? getValue() {
    if (checked.getValue() == true) {
      return valueIfChecked;
    }
    return null;
  }

  void setEnable(bool enable){
    _enable = enable;
  }

  @override
  List<Variable> gatherVariables() => [checked, valueIfChecked as Variable];

  @override
  bool enable() => _enable == true;

  @override
  bool mandatory() => _mandatory;

  @override
  ErrorResult getError() => valueIfChecked?.getError() ?? ErrorResult.NONE;
}
