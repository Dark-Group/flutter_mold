import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mold/flutter_mold.dart';
import 'package:go_router/go_router.dart';

class Window extends StatelessWidget {
  final Screen screen;
  final GoRouterState? screenState;

  Window(this.screen, this.screenState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _WindowState(this, context);
}

// ignore: must_be_immutable
class _WindowState extends MoldStatefulWidget {
  final Window window;
  final BuildContext windowContext;

  _WindowState(this.window, this.windowContext) {
    window.screen._onAttachWindowState(this);
  }

  @override
  void onCreate() {
    super.onCreate();
    window.screen.onCreate();
  }

  @override
  void onChangeAppLifecycleState(AppLifecycleState state) {
    window.screen.onChangeAppLifecycleState(state);
  }

  @override
  void onDestroy() {
    window.screen.onDestroy();
    super.onDestroy();
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    return window.screen.onCreateWidget(windowContext);
  }
}

abstract class Screen {
  _WindowState? _windowState;

  GoRouterState? get routeState => _windowState?.window.screenState;

  /// The parameters for this sub-route, e.g. {'fid': 'f2'}
  Map<String, String> get params => routeState!.params;

  String? getParam(String key) {
    return params.containsKey(key) ? params[key] : null;
  }

  /// The query parameters for the location, e.g. {'from': '/family/f2'}
  Map<String, String> get queryParams => routeState!.queryParams;

  String? getQueryParam(String key) {
    return queryParams.containsKey(key) ? queryParams[key] : null;
  }

  /// An extra object to pass along with the navigation.
  Object? get extra => routeState!.extra;

  Bundle? get bundle {
    BuildContext? context = getContext();

    if (context != null) {
      return ModalRoute.of(context)?.settings.arguments as Bundle;
    } else {
      return null;
    }
  }

  void _onAttachWindowState(_WindowState windowState) {
    _windowState = windowState;
  }

  BuildContext? getContext() => _windowState?.windowContext;

  BuildContext requiredContext() => getContext()!;

  void onCreate() {}

  void onChangeAppLifecycleState(AppLifecycleState state) {}

  String getString(String code, {List<String>? args}) => code.translate(args: args);

  void onDestroy() {}

  Widget onCreateWidget(BuildContext context);
}

// ignore: must_be_immutable
abstract class Component extends MoldStatefulWidget {}
