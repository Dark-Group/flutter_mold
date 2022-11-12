import 'dart:async' as async;

import 'package:flutter/foundation.dart';
import 'package:flutter_mold/common/extensions.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/value_array.dart';
import 'package:flutter_mold/variable/value_form.dart';
import 'package:flutter_mold/variable/variable_like.dart';
import 'package:flutter_mold/variable/variable_util.dart';

abstract class ValueModule extends ChangeNotifier implements VariableLike {
  final ValueArray<ValueForm> forms;
  final Object? tag;
  async.Timer? _debounce;

  ValueModule({required this.forms, this.tag});

  int getModuleId();

  List<ValueForm> getModuleForms() => forms.getItems().filterWhere((e) => e.isEnable()).toList();

  bool hasValue() => getModuleForms().containsWhere((e) => e.hasValue());

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
    _debounce = async.Timer(const Duration(milliseconds: 500), () {
      super.notifyListeners();
      _debounce = null;
    });
  }
}
