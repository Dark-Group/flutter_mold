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
      routes: dataRoutes.values.mapByIndex((index, e) {
        return GoRoute(
          name: e.name,
          path: e.path,
          pageBuilder: (context, screenState) {
            return MaterialPage<void>(
              key: ValueKey<String>("${screenState.location}:$index"),
              child: Window(e.builder.call(context), screenState),
            );
          },
        );
      }).toList(),
      observers: navigatorObservers,
      refreshListenable: notifier,
      redirect: (context, state) {
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
        Log.debug('Redirect: ${moldRoute.path}');
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

  static String namedLocation(
    BuildContext context,
    String routeName, {
    Bundle? bundle,
    Map<String, dynamic> params = const <String, dynamic>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    if (bundle != null && (params.isNotEmpty || queryParams.isNotEmpty)) {
      throw Exception("when using bundle don't use 'params' or 'queryParams'");
    }

    Map<String, String> mParams = {};
    params.forEach((key, value) {
      if (value?.toString().isNotEmpty == true) mParams[key] = value!.toString();
    });
    Map<String, String> mQueryParams = {};
    queryParams.forEach((key, value) {
      if (value?.toString().isNotEmpty == true) mQueryParams[key] = value!.toString();
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
    return context.namedLocation(
      routeName,
      params: mParams,
      queryParams: mQueryParams,
    );
  }

  static void openContent(
    BuildContext context,
    String routeName, {
    Bundle? bundle,
    Map<String, dynamic> params = const <String, dynamic>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) {
    GoRouter.of(context).push(
      namedLocation(context, routeName, bundle: bundle, params: params, queryParams: queryParams),
      extra: extra,
    );
  }

  static Future<R?> openContentWithResult<R>(
    BuildContext context,
    MoldRoute route, {
    Bundle? bundle,
  }) {
    return Navigator.of(context).push<R>(MaterialPageRoute(
      builder: (context) => Window(route.builder.call(context), null),
      settings: RouteSettings(name: route.name, arguments: bundle),
    ));
  }

  static void replaceContent(
    BuildContext context,
    String routeName, {
    Bundle? bundle,
    Map<String, dynamic> params = const <String, dynamic>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) {
    GoRouter.of(context).replace(
      namedLocation(context, routeName, bundle: bundle, params: params, queryParams: queryParams),
      extra: extra,
    );
  }

  static void updateContent(
    BuildContext context,
    String routeName, {
    Bundle? bundle,
    Map<String, dynamic> params = const <String, dynamic>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  }) {
    GoRouter.of(context).go(
      namedLocation(context, routeName, bundle: bundle, params: params, queryParams: queryParams),
      extra: extra,
    );
  }

  static void onBackPressed<T extends Object>(BuildContext context, [Object? result]) {
    if (result != null) {
      Navigator.of(context).pop(result);
    } else {
      GoRouter.of(context).pop();
    }
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
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
