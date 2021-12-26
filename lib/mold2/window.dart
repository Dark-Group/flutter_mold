import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/mold/mold_stateful_widget.dart';

import 'bundle.dart';

class Window extends StatelessWidget {
  final Screen screen;

  Window(this.screen);

  @override
  Widget build(BuildContext context) => new _WindowState(this, context);
}

// ignore: must_be_immutable
class _WindowState extends MoldStatefulWidget {
  final Window window;
  final BuildContext windowContext;

  _WindowState(this.window, this.windowContext) {
    this.window.screen._onAttachWindowState(this);
  }

  @override
  void onCreate() {
    super.onCreate();
    this.window.screen.onCreate();
  }

  @override
  void onDestroy() {
    this.window.screen.onDestroy();
    super.onDestroy();
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    return this.window.screen.onCreateWidget(this.windowContext);
  }
}

abstract class Screen {
  _WindowState _windowState;

  Bundle get bundle {
    BuildContext context = getContext();

    if (context != null) {
      return ModalRoute.of(context).settings.arguments;
    } else {
      return null;
    }
  }

  void onCreate() {}

  void _onAttachWindowState(_WindowState windowState) {
    this._windowState = windowState;
  }

  BuildContext getContext() => this._windowState?.windowContext;

  String getString(String code, {List<String> args}) => code.translate(args: args);

  void onDestroy() {}

  Widget onCreateWidget(BuildContext context);
}

// ignore: must_be_immutable
abstract class Component extends MoldStatefulWidget {}
