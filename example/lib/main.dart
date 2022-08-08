import 'package:flutter/material.dart';
import 'package:flutter_mold/flutter_mold.dart';

void main() {
  Mold.startApplication(ExampleApplication());
}

class ExampleApplication extends MoldApplication {
  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      IntroPage.routeName: (_) => Window(IntroPage()),
    };
  }
}

class IntroPage extends Screen {
  static const String routeName = "/";

  @override
  Widget onCreateWidget(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("First Page"),
      ),
    );
  }
}
