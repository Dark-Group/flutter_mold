import 'package:flutter/material.dart';
import 'package:flutter_mold/variable/error_result.dart';
import 'package:flutter_mold/variable/variable.dart';
import 'package:flutter_mold/variable/variable_util.dart';

class ValueArray<E extends Variable> extends ChangeNotifier implements Variable {
  final List<E> _items = <E>[];
  bool _changed = false;

  ValueArray({List<E>? items}) {
    if (items?.isNotEmpty == true) {
      this._items.addAll(items!);
    }
  }

  List<E> getItems() => this._items.map((e) => e).toList();

  void prepend(E item) {
    this._items.insert(0, item);
    this._changed = true;
    notifyListeners();
  }

  void append(E item) {
    this._items.add(item);
    this._changed = true;
    notifyListeners();
  }

  void delete(final E item) {
    this._items.removeWhere((e) => e == item);
    this._changed = true;
    notifyListeners();
  }

  void deleteWhere(bool onWhere(E element)) {
    this._items.removeWhere(onWhere);
    this._changed = true;
    notifyListeners();
  }

  void clear() {
    this._items.clear();
    this._changed = true;
    notifyListeners();
  }

  void addAll(final List<E> values) {
    this._items.addAll(values);
    this._changed = true;
    notifyListeners();
  }

  void setValue(final List<E> values) {
    this._items.clear();
    this._items.addAll(values);
    this._changed = true;
    notifyListeners();
  }

  bool get isEmpty => this._items.isEmpty;

  bool get nonEmpty => !isEmpty;

  @override
  void readyToChange() {
    this._changed = false;
    VariableUtil.readyToChange(this._items);
  }

  @override
  bool mandatory() => VariableUtil.mandatory(this._items);

  @override
  bool modified() {
    return this._changed || VariableUtil.modified(this._items);
  }

  @override
  ErrorResult getError() => VariableUtil.getError(this._items);
}
