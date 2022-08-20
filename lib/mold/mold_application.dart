import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/mold/style.dart';
import 'package:flutter_mold/mold2/window.dart';
import 'package:go_router/go_router.dart';

typedef BuildWidget = Widget Function(BuildContext context);

typedef ScreenBuilder = Screen Function(BuildContext context);

class MoldRoute {
  final String? name;
  final String path;
  final ScreenBuilder builder;

  MoldRoute({this.name, required this.path, required this.builder});
}

class MoldRouteState {
  final GoRouterState routerState;

  MoldRouteState(this.routerState);

  String get location => routerState.location;

  String get subloc => routerState.subloc;

  String? get name => routerState.name;

  String? get path => routerState.path;

  String? get fullPath => routerState.fullpath;
}

abstract class MoldApplication {
  Future<MoldColor?> getColor() {
    return Future.value(null);
  }

  Future<MoldTheme?> getTheme() {
    return Future.value(null);
  }

  void onCreate() {}

  void onDestroy() {}

  List<MoldRoute> getRoutes();

  Map<String, String> getTranslates(String langCode) {
    return <String, String>{
      "mold:date_util:hour": "%1s ч",
      "mold:date_util:minute": "%1s мин",
      "mold:date_util:hour_minute": "%1s ч %2s мин",
      "mold:error:error_conection_fail": "Нет соединения с интернетом (connection fail)",
      "mold:error:error_conection_refused": "Нет соединения с интернетом (connection refused)",
      "mold:error:error_http_not_found": "Нет соединения с интернетом (http not found)",
      "mold:error:error_connection_timeout": "Скорость интернета низкая или нет подключения (connection timeout)",
      "mold:error:error_incorrect_login_or_password": "Неверный логин или пароль ",
      "mold:spinner_option:not_selected": "Не выбран",
    };
  }

  String? redirect(MoldRouteState state, MoldChangeNotifier notifier) {
    return null;
  }
}

class MoldApplicationWidget extends InheritedNotifier<MoldChangeNotifier> {
  final MoldApplication application;

  const MoldApplicationWidget(
    Widget child,
    this.application,
    MoldChangeNotifier notifier, {
    Key? key,
  }) : super(key: key, notifier: notifier, child: child);

  static MoldChangeNotifier of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MoldApplicationWidget>()!.notifier!;
}

class MoldChangeNotifier extends ChangeNotifier {
  static MoldChangeNotifier? _instance;

  static MoldColor getColor() => _instance!.color;

  static MoldTheme getTheme() => _instance!.theme;

  final AppLang appLang = AppLang.instance;

  MoldChangeNotifier() {
    _instance = this;
  }

  Future<void> changeLanguage(String langCode) async {
    appLang.changeLanguage(langCode);
    notifyListeners();
  }

  MoldColor? _color;
  MoldTheme? _theme;

  MoldColor get color => _color!;

  MoldTheme get theme => _theme!;

  void initColor({MoldColor? color}) {
    _color = color ?? MoldColor();
    notifyListeners();
  }

  void initTheme({MoldTheme? theme}) {
    _theme = theme ?? MoldTheme();
    notifyListeners();
  }
}
