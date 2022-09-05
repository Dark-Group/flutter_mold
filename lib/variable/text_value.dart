import 'package:flutter/material.dart';
import 'package:flutter_mold/variable/variable.dart';

abstract class TextValue implements Variable {
  VoidCallback? _controllerListener;

  String getText();

  void setText(String text);
}

class VariableText {
  static void bind(TextValue variable, TextEditingController controller) {
    if (variable._controllerListener != null) {
      controller.removeListener(variable._controllerListener!);
      variable._controllerListener = null;
    }

    controller.text = variable.getText();

    variable._controllerListener = () {
      variable.setText(controller.text);
    };
    controller.addListener(variable._controllerListener!);
  }
}
