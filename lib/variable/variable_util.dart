import 'package:flutter/cupertino.dart';
import 'package:flutter_mold/common/extensions.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable.dart';

class VariableUtil {
  static void readyToChange(List<Variable?> items) {
    items.where((e) => e != null).forEach((e) => e!.readyToChange());
  }

  static bool mandatory(List<Variable?> items) {
    return items.filterNotNull().containsWhere((e) => e.mandatory());
  }

  static bool modified(List<Variable?> items) {
    return items.filterNotNull().containsWhere((e) => e.modified());
  }

  static ErrorResult getError(List<Variable?> items) {
    return items.filterNotNull().map((e) => e.getError()).findWhere((e) => e.isError()) ??
        ErrorResult.NONE;
  }

  static void addListener(List<ChangeNotifier?> items, VoidCallback callback) {
    items.filterNotNull().forEach((e) => e.addListener(callback));
  }

  static void removeListener(List<ChangeNotifier?> items, VoidCallback callback) {
    items.filterNotNull().forEach((e) => e.addListener(callback));
  }
}
