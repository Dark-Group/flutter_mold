import 'package:flutter/material.dart';

class GStyle {
  static GStyle _instance;

  static GStyle getInstance() {
    if (_instance == null) {
      _instance = GStyle._();
      _instance._theme = GThemeLight();
    }
    return _instance;
  }

  static GTheme getTheme() {
    return getInstance().theme;
  }

  static GStyle init({GTheme theme}) {
    _instance = GStyle._();
    _instance._theme = theme ?? GThemeLight();
    return _instance;
  }

  GStyle._();

  GTheme _theme;

  GTheme get theme => _theme;
}

class GTheme {
  Color get appColor => Color(0xFF6563FF);

  Color get errorTextColor => Color(0xFF43130F);

  Color get errorIconColor => Color(0xFFC8372D);

  Color get errorBackgroundColor => Color(0xFFFDD4D1);

  Color get warningTextColor => Color(0xFF463209);

  Color get warningIconColor => Color(0xFFB88217);

  Color get warningBackgroundColor => Color(0xFFFFE5B2);

  Color get infoTextColor => Color(0xFF0C2146);

  Color get infoIconColor => Color(0xFF2264D1);

  Color get infoBackgroundColor => Color(0xFFD8E6FF);

  Color get primary_1 => Color(0xFF1B82E3);

  Color get status_diabled => Color(0xFFC9CDD0);

  Color get status_success => Color(0xFF82A846);

  Color get background => Color(0xFFE0E2E5);

  Color get block_surface_1 => Color(0xFFFFFFFF);

  Color get block_surface_2 => Color(0xFFF5F6F7);

  Color get primary_2 => Color(0xFF32508A);

  Color get primary_3 => Color(0xFF0C2A3E);

  Color get border_low_emphasis => Color(0x290E161C);

  Color get text_primary_medium_emphasis => Color(0x60FFFFFF);

  Color get text_primary_hight_emphasis => Color(0xDEFFFFFF);

  Color get text_high_emphasis => Color(0xFF0C2A3E).withOpacity(0.9);

  Color get text_medium_emphasis => Color(0x0C2A3E).withOpacity(0.71);

  Color get border_medium_emphasis => Color(0x00000000).withOpacity(0.24);

  Color get status_error => Color(0xFFCC5367);

  Color get border_on_primary_high_emphasis => Color(0x52FFFFFF);
}

class GThemeLight extends GTheme {}
