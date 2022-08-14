import 'package:flutter_mold/flutter_mold.dart';

class VariableStream<V extends TextValue> extends TextValue {
  final V _variable;
  bool _enable;

  VariableStream(
    this._variable, {
    bool enable = true,
  }) : _enable = enable == true;

  final LazyStream<V?> _change = LazyStream();

  Stream<V?> getStream() => _change.stream;

  void notifyListeners() {
    _change.add(_variable);
  }

  @override
  void setText(String text) {
    _variable.setText(text);
    notifyListeners();
  }

  @override
  String getText() => _variable.getText();

  void setEnable(bool enable) {
    _enable = enable;
    notifyListeners();
  }

  @override
  void readyToChange() {
    _variable.readyToChange();
  }

  @override
  bool enable() => _enable == true;

  @override
  bool mandatory() {
    return _variable.mandatory();
  }

  @override
  bool modified() {
    return _variable.modified();
  }

  @override
  ErrorResult getError() {
    return _variable.getError();
  }

  void dispose() {
    _change.close();
  }
}
