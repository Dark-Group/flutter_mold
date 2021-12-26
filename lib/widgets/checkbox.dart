import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mold/common/lazy_stream.dart';
import 'package:flutter_mold/mold/mold_stateful_widget.dart';

// ignore: must_be_immutable
class MyCheckBox extends MoldStatefulWidget {
  bool check;
  LazyStream<bool> _subject = new LazyStream();

  MyCheckBox(this.check, [void onCheckedChange(bool checked)]) {
    this._listener = onCheckedChange;
  }

  void Function(bool checked) _listener;

  MyCheckBox setListener(void onCheckedChange(bool checked)) {
    this._listener = onCheckedChange;
    return this;
  }

  @override
  void onCreate() {
    super.onCreate();
    _subject.stream.listen((value) {
      if (value != null) {
        _listener?.call(value);
      }
    });
  }

  @override
  void onDestroy() {
    _subject.close();
    super.onDestroy();
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    return StreamBuilder(
      initialData: check,
      stream: _subject.stream,
      builder: (buildContext, snapshot) {
        return Checkbox(value: snapshot.data ?? check, onChanged: _subject.add);
      },
    );
  }

  bool get isChecked => _subject?.value ?? false;

  set setChecked(bool value) => _subject?.add(value);
}
