import 'dart:async' as async;

import 'package:flutter/foundation.dart';
import 'package:flutter_mold/common/list_extension.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/value_array.dart';
import 'package:flutter_mold/variable/value_form.dart';
import 'package:flutter_mold/variable/variable_like.dart';
import 'package:flutter_mold/variable/variable_util.dart';

abstract class ValueModule extends ChangeNotifier implements VariableLike {
  final ValueArray<ValueForm> forms = new ValueArray();
  final Object? tag;
  async.Timer? _debounce;

  ValueModule({@required ValueArray<ValueForm>? forms, this.tag}) {
    this.forms.addAll(forms?.getItems() ?? []);
  }

  int getModuleId();

  List<ValueForm> getModuleForms() => forms.getItems().filterWhere((e) => e.isEnable()).toList();

  bool hasValue() => this.getModuleForms().containsWhere((e) => e.hasValue());

  @override
  void readyToChange() => forms.readyToChange();

  @override
  bool modified() => forms.modified();

  @override
  ErrorResult getError() => VariableUtil.getError(gatherVariables());

  @override
  bool mandatory() => forms.mandatory();

  @override
  void notifyListeners() {
    _debounce?.cancel();
    _debounce = async.Timer(Duration(milliseconds: 500), () {
      super.notifyListeners();
      _debounce = null;
    });
  }
}
