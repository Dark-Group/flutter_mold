import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle TS_ErrorText({Color textColor = Colors.redAccent, double fontSize = 12.0}) {
  return TextStyle(color: textColor, fontSize: fontSize, letterSpacing: 0.4);
}

TextStyle TS_Title_1([Color? color]) {
  Color textColor = color ?? Colors.black87;
  return TextStyle(
    color: textColor,
    fontSize: 34.0,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w200,
    letterSpacing: -0.25,
  );
}

TextStyle TS_Title_2([Color? color, double fontSize = 24]) {
  Color textColor = color ?? Colors.black87;
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
  );
}

TextStyle TS_Title_3([Color? color, double fontSize = 20]) {
  Color textColor = color ?? Colors.black87;
  return TextStyle(
    color: textColor,
    fontSize: fontSize,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w300,
    letterSpacing: 0.15,
  );
}

TextStyle TS_Button([Color textColor = Colors.black87]) {
  return TextStyle(
    color: textColor,
    fontSize: 14,
    letterSpacing: 0.4,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w500,
  );
}
