import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mold/mold/mold_application.dart';

class MoldStyle {
  static final MoldStyle instance = MoldStyle._();

  static MoldTheme getTheme() {
    return instance.theme;
  }

  static MoldColor getColor() {
    return instance.color;
  }

  MoldStyle._();

  MoldTheme? _theme;

  MoldTheme get theme => _theme!;

  MoldColor? _color;

  MoldColor get color => _color!;

  bool get isInit => _theme != null && _color != null;

  MoldStyle initColor({MoldColor? color, bool notify = false}) {
    instance._color = color ?? MoldColor();
    if (notify) {
      App.notify();
    }
    return instance;
  }

  MoldStyle initTheme({MoldTheme? theme, bool notify = false}) {
    instance._theme = theme ?? MoldTheme();
    if (notify) {
      App.notify();
    }
    return instance;
  }
}

class MoldTheme {
  //
}

class MoldColor {
  final Brightness brightness = Brightness.light;
  final SystemUiOverlayStyle systemStyle = SystemUiOverlayStyle.light;
  final Color app_color = Color(0xFF1B82E3);
  final Color background = Color(0xFFCCCCCC);
}
