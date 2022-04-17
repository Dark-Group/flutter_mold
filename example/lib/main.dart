import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mold/flutter_mold.dart';

void main() {
  MoldApplication app = MyApp();
  Mold.startApplication(app);
}

class MyApp extends MoldApplication {
  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      "/": (_) => Window(IntroScreen()),
      SecondScreen.routeName: (_) => Window(SecondScreen()),
    };
  }
}

class IntroScreen extends Screen {
  @override
  Widget onCreateWidget(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Hello"),
          TextButton(
            onPressed: () {
              SecondScreen.open(getRequiredContext(), Random.secure().nextInt(100));
            },
            child: Text("Next"),
          )
        ],
      ),
    );
  }
}

class SecondScreen extends Screen {
  static const String routeName = "/second";

  static void open(BuildContext context, int personId) {
    print('person_id: $personId');
    final bundle = Bundle.newBundle(context, {"person_id": personId});
    Mold.openContent(context, routeName, bundle: bundle);
  }

  int get personId => bundle?.getInt("person_id") ?? -1;

  @override
  Widget onCreateWidget(BuildContext context) {
    return Scaffold(
      body: Text("Second Screen with argument\nPersonId : $personId"),
    );
  }
}
