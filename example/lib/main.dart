import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mold/flutter_mold.dart';

void main() {
  Mold.startApplication(ExampleApplication());
}

class ExampleApplication extends MoldApplication {
  @override
  List<MoldRoute> getRoutes() {
    return [
      IntroPage.route,
      FirstPage.route,
      MainPage.route,
    ];
  }
}

class IntroPage extends Screen {
  static const String routeName = "index";
  static final MoldRoute route = MoldRoute(name: routeName, path: "/", builder: (_) => IntroPage());

  @override
  Widget onCreateWidget(BuildContext context) {
    var appLang = MoldApplicationWidget.of(context).appLang;
    return Scaffold(
      body: Center(
        child: MyTable.vertical([
          Text("Intro Page\n\n${appLang.getLangCode()}"),
          MyText(
            "open first page",
            onTap: () => FirstPage.open(requiredContext()),
          ),
        ]),
      ),
    );
  }
}

class FirstPage extends Screen {
  static const String routeName = "first";

  static final MoldRoute route = MoldRoute(name: routeName, path: "/first", builder: (_) => FirstPage());

  static void open(BuildContext context) {
    Mold.openContent(context, routeName);
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    var appLang = MoldApplicationWidget.of(context).appLang;
    return Scaffold(
      body: Center(
        child: MyTable.vertical([
          Text("First Page\n\nLangCode: ${appLang.getLangCode()}"),
          MyText(
            "Open Main Page",
            onTap: () => MainPage.open(
              requiredContext(),
              Random.secure().nextInt(100).toString(),
            ),
          ),
        ]),
      ),
    );
  }
}

class MainPage extends Screen {
  static const String routeName = "main";
  static final MoldRoute route = MoldRoute(name: routeName, path: "/:company/main", builder: (_) => MainPage());

  static void open(BuildContext context, String companyId) {
    Mold.openContent(context, routeName, params: {"company": companyId});
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    var appLang = MoldApplicationWidget.of(context).appLang;
    return Scaffold(
      body: Center(
        child: MyTable.vertical([
          Text("Main page\nAppLang: is -> ${appLang.getLangCode()}"),
          MyText(
            "Change Notifier",
            onTap: () {
              if (appLang.getLangCode() == "ru") {
                MoldApplicationWidget.of(context).changeLanguage("en");
              } else {
                MoldApplicationWidget.of(context).changeLanguage("ru");
              }
            },
          ),
        ]),
      ),
    );
  }
}

// // import 'package:flutter/material.dart';
// // import 'dart:async';
// //
// // import 'package:flutter/services.dart';
// // import 'package:flutter_mold/flutter_mold.dart';
// //
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatefulWidget {
// //   const MyApp({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }
// //
// // class _MyAppState extends State<MyApp> {
// //   String _platformVersion = 'Unknown';
// //   final _flutterMoldPlugin = FlutterMold();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initPlatformState();
// //   }
// //
// //   // Platform messages are asynchronous, so we initialize in an async method.
// //   Future<void> initPlatformState() async {
// //     String platformVersion;
// //     // Platform messages may fail, so we use a try/catch PlatformException.
// //     // We also handle the message potentially returning null.
// //     try {
// //       platformVersion =
// //           await _flutterMoldPlugin.getPlatformVersion() ?? 'Unknown platform version';
// //     } on PlatformException {
// //       platformVersion = 'Failed to get platform version.';
// //     }
// //
// //     // If the widget was removed from the tree while the asynchronous platform
// //     // message was in flight, we want to discard the reply rather than calling
// //     // setState to update our non-existent appearance.
// //     if (!mounted) return;
// //
// //     setState(() {
// //       _platformVersion = platformVersion;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Plugin example app'),
// //         ),
// //         body: Center(
// //           child: Text('Running on: $_platformVersion\n'),
// //         ),
// //       ),
// //     );
// //   }
// // }
