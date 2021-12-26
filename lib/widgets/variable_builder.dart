import 'package:flutter/material.dart';
import 'package:flutter_mold/widgets/widget.dart';
import 'package:provider/provider.dart';

typedef VariableWidgetBuilder<T> = Widget Function(BuildContext context, T model);

class VariableBuilder<T extends ChangeNotifier> extends MyWidget {
  final T value;
  final VariableWidgetBuilder<T> builder;

  VariableBuilder({@required this.value, @required this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: value,
      child: new Consumer<T>(builder: (context, model, child) => builder.call(context, model)),
    );
  }
}
