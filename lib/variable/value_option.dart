import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/value_bool.dart';
import 'package:flutter_mold/variable/variable.dart';
import 'package:flutter_mold/variable/variable_like.dart';

class ValueOption<T extends Variable> extends VariableLike {
  final String title;
  final ValueBool checked = new ValueBool();
  final T? valueIfChecked;
  final dynamic tag;
  final bool _mandatory;

  ValueOption({required this.title, required this.valueIfChecked, this.tag, bool mandatory = false})
      : this._mandatory = mandatory {
    if (this.valueIfChecked == null) {
      throw Exception("value  if checked is null");
    }
  }

  T? getValue() {
    if (checked.getValue() == true) {
      return valueIfChecked;
    }
    return null;
  }

  @override
  List<Variable> gatherVariables() => [this.checked, this.valueIfChecked as Variable];

  @override
  bool mandatory() => this._mandatory;

  @override
  ErrorResult getError() => this.valueIfChecked?.getError() ?? ErrorResult.NONE;
}
