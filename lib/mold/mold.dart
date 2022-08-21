import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mold/flutter_mold.dart';
import 'package:go_router/go_router.dart';

class Mold {
  static void startApplication(
    MoldApplication application, {
    MoldChangeNotifier? notifier,
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
    Function? onError,
  }) {
    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();

      final changeNotifier = notifier ?? MoldChangeNotifier();
      changeNotifier.initColor(color: await application.getColor());
      changeNotifier.initTheme(theme: await application.getTheme());

      await AppLang.instance.init();

      final platformApp = getPlatformApp(application, changeNotifier, navigatorObservers);

      runApp(MoldApplicationWidget(
        platformApp,
        application,
        changeNotifier,
      ));
    }, (error, st) {
      Log.error(error, st);
      onError?.call(error, st);
    });
  }

  static Widget getPlatformApp(
    MoldApplication application,
    MoldChangeNotifier notifier,
    List<NavigatorObserver> navigatorObservers,
  ) {
    final color = notifier.color;
    Map<String, MoldRoute> dataRoutes = {};
    application.getRoutes().forEach((route) {
      dataRoutes[route.name] = route;
    });
    var goRouter = GoRouter(
      initialLocation: "/",
      routes: dataRoutes.values.map((e) {
        return GoRoute(
          name: e.name,
          path: e.path,
          builder: (context, screenState) => Window(e.builder.call(context), screenState),
        );
      }).toList(),
      observers: navigatorObservers,
      refreshListenable: notifier,
      redirect: (state) {
        Log.debug("State: ${state.location}, SubLoc: ${state.subloc}");
        final redirectName = application.redirect(
          MoldRouteState(state),
          notifier,
        );
        if (redirectName == null) return null;

        final moldRoute = dataRoutes[redirectName];
        if (moldRoute == null) {
          throw Exception("page not found, redirect 404 page");
        }
        print('Redirect: ${moldRoute.path}');
        return moldRoute.path;
      },
    );

    if (kIsWeb) {
      return MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          brightness: color.brightness,
          toggleableActiveColor: color.appColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: color.brightness,
            secondary: color.appColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        //
        routeInformationProvider: goRouter.routeInformationProvider,
        routeInformationParser: goRouter.routeInformationParser,
        routerDelegate: goRouter.routerDelegate,
        //
        locale: AppLang.instance.getLocale(),
        supportedLocales: AppLang.instance.getSupportLangs(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );
    } else if (Platform.isIOS) {
      return CupertinoApp.router(
        theme: CupertinoThemeData(
          brightness: color.brightness,
          primaryColor: color.appColor,
          primaryContrastingColor: color.appColor,
        ),
        debugShowCheckedModeBanner: false,
        //
        routeInformationProvider: goRouter.routeInformationProvider,
        routeInformationParser: goRouter.routeInformationParser,
        routerDelegate: goRouter.routerDelegate,
        //
        locale: AppLang.instance.getLocale(),
        supportedLocales: AppLang.instance.getSupportLangs(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );
    } else {
      return MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          brightness: color.brightness,
          toggleableActiveColor: color.appColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            brightness: color.brightness,
            secondary: color.appColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        //
        routeInformationProvider: goRouter.routeInformationProvider,
        routeInformationParser: goRouter.routeInformationParser,
        routerDelegate: goRouter.routerDelegate,
        //
        locale: AppLang.instance.getLocale(),
        supportedLocales: AppLang.instance.getSupportLangs(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );
    }
  }

  static void openContent<R>(
    BuildContext context,
    String routeName, {
    Bundle? bundle,
    Map<String, String?> params = const <String, String>{},
    Map<String, String?> queryParams = const <String, String>{},
    Object? extra,
  }) {
    if (bundle != null && (params.isNotEmpty || queryParams.isNotEmpty)) {
      throw Exception("when using bundle don't use 'params' or 'queryParams'");
    }

    Map<String, String> mParams = {};
    params.forEach((key, value) {
      if (value?.isNotEmpty == true) mParams[key] = value!;
    });
    Map<String, String> mQueryParams = {};
    queryParams.forEach((key, value) {
      if (value?.isNotEmpty == true) mQueryParams[key] = value!;
    });

    // generate param & query via bundle data
    if (bundle != null) {
      var bundleData = bundle.getData();
      for (var key in bundleData.keys) {
        if (!routeName.contains("/:$key")) {
          continue;
        }
        mParams[key] = bundleData[key]!;
        bundleData.remove(key);
      }
      mQueryParams.addAll(bundleData);
    }

    final route = context.namedLocation(
      routeName,
      params: mParams,
      queryParams: mQueryParams,
    );
    GoRouter.of(context).push(route, extra: extra);
  }

  static void replaceContent<R>(
    BuildContext context,
    String routeName, {
    Bundle? bundle,
    Map<String, String?> params = const <String, String>{},
    Map<String, String?> queryParams = const <String, String>{},
    Object? extra,
  }) {
    if (bundle != null && (params.isNotEmpty || queryParams.isNotEmpty)) {
      throw Exception("when using bundle don't use 'params' or 'queryParams'");
    }

    Map<String, String> mParams = {};
    params.forEach((key, value) {
      if (value != null) mParams[key] = value;
    });
    Map<String, String> mQueryParams = {};
    queryParams.forEach((key, value) {
      if (value != null) mQueryParams[key] = value;
    });

    // generate param & query via bundle data
    if (bundle != null) {
      var bundleData = bundle.getData();
      for (var key in bundleData.keys) {
        if (!routeName.contains("/:$key")) {
          continue;
        }
        mParams[key] = bundleData[key]!;
        bundleData.remove(key);
      }
      mQueryParams.addAll(bundleData);
    }

    final route = GoRouter.of(context).namedLocation(
      routeName,
      params: mParams,
      queryParams: mQueryParams,
    );
    GoRouter.of(context).replace(route, extra: extra);
  }

  static void onBackPressed<T extends Object>(BuildContext context) {
    GoRouter.of(context).pop();
  }

  static bool canPop(BuildContext context) {
    return GoRouter.of(context).canPop();
  }

  static void hideKeyboard() {
    /*
   // bunda Screen onCreate chaqirib yuboribdi shuning uchun quyidagicha yechim qilindi.
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }*/
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (error, st) {
      Log.error(error, st);
    }
  }

  static void focusKeyboard(BuildContext context, [FocusNode? node]) {
    FocusScope.of(context).requestFocus(node);
  }
}
