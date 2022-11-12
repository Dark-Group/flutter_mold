import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mold/common/setter.dart';
import 'package:flutter_mold/flutter_mold.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

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

  final Setter<ScreenSizing> screenSetup = Setter();

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
    return ResponsiveBuilder(
      builder: (context, sizing) {
        screenSetup.value = ScreenSizing(sizing);
        Widget? widget;

        final isDesktop = sizing.isDesktop;
        final isTablet = sizing.isTablet;
        final isMobile = sizing.isMobile;

        if (isDesktop) {
          widget = window.screen.onCreateDesktopWidget(windowContext);
        }

        if ((widget == null && isDesktop) || isTablet) {
          widget = window.screen.onCreateTabletWidget(windowContext);
        }

        if ((widget == null && (isDesktop || isTablet)) || isMobile) {
          widget = window.screen.onCreateMobileWidget(windowContext);
        }

        return widget ??= window.screen.onCreateWidget(windowContext);
      },
    );
  }
}

class ScreenSizing {
  final SizingInformation sizingInformation;

  ScreenSizing(this.sizingInformation);

  bool get isMobile => sizingInformation.isMobile;

  bool get isTablet => sizingInformation.isTablet;

  bool get isDesktop => sizingInformation.isDesktop;

  bool get isWatch => sizingInformation.isWatch;

  // Refined

  RefinedSize get refinedSize => sizingInformation.refinedSize;

  bool get isExtraLarge => sizingInformation.isExtraLarge;

  bool get isLarge => sizingInformation.isLarge;

  bool get isNormal => sizingInformation.isNormal;

  bool get isSmall => sizingInformation.isSmall;
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

  ScreenSizing? getScreenInformation() => _windowState?.screenSetup.value;

  void onCreate() {}

  void onChangeAppLifecycleState(AppLifecycleState state) {}

  String getString(String code, {List<String>? args}) => code.translate(args: args);

  void onDestroy() {}

  Widget onCreateWidget(BuildContext context);

  Widget? onCreateDesktopWidget(BuildContext context) {
    return null;
  }

  Widget? onCreateTabletWidget(BuildContext context) {
    return null;
  }

  Widget? onCreateMobileWidget(BuildContext context) {
    return null;
  }
}

// ignore: must_be_immutable
abstract class Component extends MoldStatefulWidget {}
