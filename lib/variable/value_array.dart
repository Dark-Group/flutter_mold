import 'package:flutter/material.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable.dart';
import 'package:flutter_mold/variable/variable_util.dart';

class ValueArray<E extends Variable> extends ChangeNotifier implements Variable {
  final List<E> _items;
  bool _changed = false;
  bool _enable;

  ValueArray({List<E>? items, bool enable = true})
      : _items = <E>[],
        _enable = enable == true {
    if (items != null && items.isNotEmpty) {
      _items.addAll(items);
    }
    _changed = false;
  }

  List<E> getItems() => _items.map((e) => e).toList();

  void prepend(E item) {
    _items.insert(0, item);
    _changed = true;
    notifyListeners();
  }

  void append(E item) {
    _items.add(item);
    _changed = true;
    notifyListeners();
  }

  void delete(final E item) {
    _items.removeWhere((e) => e == item);
    _changed = true;
    notifyListeners();
  }

  void deleteWhere(bool onWhere(E element)) {
    _items.removeWhere(onWhere);
    _changed = true;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _changed = true;
    notifyListeners();
  }

  void addAll(final List<E> values) {
    _items.addAll(values);
    _changed = true;
    notifyListeners();
  }

  void setValue(final List<E> values) {
    _items.clear();
    _items.addAll(values);
    _changed = true;
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;

  bool get nonEmpty => !isEmpty;

  void setEnable(bool enable) {
    _enable = enable;
    notifyListeners();
  }

  @override
  void readyToChange() {
    _changed = false;
    VariableUtil.readyToChange(_items);
  }

  @override
  bool enable() => _enable == true;

  @override
  bool mandatory() => VariableUtil.mandatory(_items);

  @override
  bool modified() {
    return _changed || VariableUtil.modified(_items);
  }

  @override
  ErrorResult getError() => VariableUtil.getError(_items);
}
