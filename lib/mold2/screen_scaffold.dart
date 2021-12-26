import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'window.dart';

abstract class ScaffoldScreen extends Screen {
  final _Bloc _bloc = new _Bloc();

  Widget onBuildBody(BuildContext context);

  ScaffoldScreen setBackgroundColor(Color background) {
    this._bloc.backgroundColor = background;
    return this;
  }

  ScaffoldScreen setAppBar(PreferredSizeWidget appbar) {
    this._bloc.appBar = appbar;
    return this;
  }

  ScaffoldScreen setFloatActionButton(Widget button) {
    this._bloc._floatActionButton = button;
    return this;
  }

  @override
  Widget onCreateWidget(BuildContext _) {
    BuildContext ctx = getContext();
    return ChangeNotifierProvider<_Bloc>.value(
      value: _bloc,
      child: new Consumer<_Bloc>(builder: (_, model, child) {
        return Scaffold(
          appBar: model._appBar,
          body: this.onBuildBody(ctx),
          floatingActionButton: model._floatActionButton,
          backgroundColor: model._backgroundColor,
        );
      }),
    );
  }
}

class _Bloc extends ChangeNotifier {
  Color _backgroundColor;

  set backgroundColor(Color newValue) {
    this._backgroundColor = newValue;
    super.notifyListeners();
  }

  PreferredSizeWidget _appBar;

  set appBar(Widget newValue) {
    this._appBar = newValue;
    super.notifyListeners();
  }

  Widget _floatActionButton;

  set floatActionButton(Widget newValue) {
    this._floatActionButton = newValue;
    super.notifyListeners();
  }
}
