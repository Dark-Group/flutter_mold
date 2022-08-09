import 'package:flutter/material.dart';
import 'package:flutter_mold/common/lazy_stream.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/mold/mold_stateful_widget.dart';
import 'package:flutter_mold/mold/style.dart';
import 'package:provider/provider.dart';

typedef BuildWidget = Widget Function(BuildContext context);

abstract class MoldApplication {
  MoldApplicationWidget? _applicationWidget;

  void _onInit(MoldApplicationWidget applicationWidget) {
    this._applicationWidget = applicationWidget;
  }

  bool isInit() => _applicationWidget != null;

  BuildContext? get applicationContext => isInit() ? _applicationWidget!.getContext() : null;

  void onCreate() {
    assert(isInit());
  }

  void onDestroy() {}

  Future<MoldColor> getColor() {
    return Future<MoldColor>.value(null);
  }

  Future<MoldTheme> getTheme() {
    return Future<MoldTheme>.value(null);
  }

  Map<String, WidgetBuilder> getRoutes();

  Map<String, String> getTranslates(String langCode) {
    return <String, String>{
      "gwslib:date_util:hour": "%1s ч",
      "gwslib:date_util:minute": "%1s мин",
      "gwslib:date_util:hour_minute": "%1s ч %2s мин",
      "gwslib:error:error_conection_fail": "Нет соединения с интернетом (connection fail)",
      "gwslib:error:error_conection_refused": "Нет соединения с интернетом (connection refused)",
      "gwslib:error:error_http_not_found": "Нет соединения с интернетом (http not found)",
      "gwslib:error:error_connection_timeout": "Скорость интернета низкая или нет подключения (connection timeout)",
      "gwslib:error:error_incorrect_login_or_password": "Неверный логин или пароль ",
      "gwslib:spinner_option:not_selected": "Не выбран",
    };
  }
}

class MoldApplicationWidget extends StatelessWidget {
  static MoldApplicationWidget? _applicationWidget;
  BuildContext? _context;

  void _setContext(BuildContext context) {
    _context = context;
  }

  BuildContext? getContext() => _context;

  BuildContext requiredContext() => getContext()!;

  static MoldApplicationWidget getInstance() {
    return _applicationWidget!;
  }

  final MoldApplication application;
  final BuildWidget buildChildWidget;

  MoldApplicationWidget(this.buildChildWidget, this.application) {
    _applicationWidget = this;
  }

  final LazyStream<bool> reloadScreen = new LazyStream(() => false);

  bool isWaitReloadScreen = false;

  void runReloadScreen() {
    if (isWaitReloadScreen) return;
    isWaitReloadScreen = true;

    Future.delayed(Duration(milliseconds: 1000), () {
      this.reloadScreen.add(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    _setContext(context);

    if (!application.isInit()) {
      application._onInit(this);
      application.onCreate();
    }

    if (!AppLang.instance.isInit) {
      AppLang.instance.onGetTranslate = application.getTranslates;
      AppLang.instance.init();
    }

    if (!MoldStyle.instance.isInit) {
      MoldStyle.instance.initColor();

      application
          .getColor()
          .then((appColor) => MoldStyle.instance.initColor(color: appColor))
          .then((_) => this.application.getTheme())
          .then((appTheme) => MoldStyle.instance.initTheme(theme: appTheme))
          .then((value) => App.notify());
    }

    this.runReloadScreen();

    return new StreamBuilder<bool?>(
        stream: reloadScreen.stream,
        initialData: reloadScreen.value,
        builder: (_, st) {
          if (st.data != true) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            );
          }
          return _AppState(this);
        });
  }
}

class _AppState extends MoldStatefulWidget {
  MoldApplicationWidget appWidget;

  _AppState(this.appWidget);

  @override
  void onChangeAppLifecycleState(AppLifecycleState state) {
    super.onChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      appWidget.application.onDestroy();
    }
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    return ChangeNotifierProvider<_AppChangeProvider>(
      create: (_) => _AppChangeProvider.instance,
      child: Consumer<_AppChangeProvider>(builder: (context, model, child) {
        if (!model.isInit) return Container();
        return appWidget.buildChildWidget.call(context);
      }),
    );
  }
}

class App {
  static void notify() {
    _AppChangeProvider.instance.notify();
  }

  static AppLang get appLang => _AppChangeProvider.instance.appLang;
}

class _AppChangeProvider extends ChangeNotifier {
  static final _AppChangeProvider instance = new _AppChangeProvider();

  final AppLang appLang = AppLang.instance;

  final MoldStyle style = MoldStyle.instance;

  bool get isInit => appLang.isInit && style.isInit;

  void notify() {
    super.notifyListeners();
  }
}
