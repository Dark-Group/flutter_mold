import 'package:flutter/material.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/widgets/widget.dart';

class MyTextBloc extends ChangeNotifier {
  //------------------------------------------------------------------------------------------------
  // String value to upper case
  // @example "Hello World" -> "HELLO WORLD!"
  //------------------------------------------------------------------------------------------------
  bool _upperCase;

  set upperCase(bool upper) {
    _upperCase = upper;
    notifyListeners();
  }

  //------------------------------------------------------------------------------------------------
  // String value to lower case
  // @example "Hello World" -> "hello world!"
  //------------------------------------------------------------------------------------------------
  bool _lowerCase;

  set lowerCase(bool lower) {
    _lowerCase = lower;
    notifyListeners();
  }

  //------------------------------------------------------------------------------------------------
  // String singleLine
  //------------------------------------------------------------------------------------------------
  bool _singleLine;

  set singleLine(bool newValue) {
    _singleLine = newValue;
    notifyListeners();
  }

  //------------------------------------------------------------------------------------------------
  // String value
  //------------------------------------------------------------------------------------------------
  String _text;

  set text(String newValue) {
    _text = newValue;
    notifyListeners();
  }

  get text {
    var value = _text ?? "";
    if (value.isNotEmpty) {
      value = AppLang.instance.translate(value);
      if (_upperCase ?? false) {
        value = value.toUpperCase();
      } else if (_lowerCase ?? false) {
        value = value.toLowerCase();
      }
    }
    return value;
  }

  //------------------------------------------------------------------------------------------------
  // Text style
  //------------------------------------------------------------------------------------------------
  TextStyle _style;

  set style(TextStyle newValue) {
    _style = newValue;
    notifyListeners();
  }

  get style => _style ?? TextStyle();

  //------------------------------------------------------------------------------------------------
  // Text style
  //------------------------------------------------------------------------------------------------
  TextAlign _textAlign;

  set textAlign(TextAlign newValue) {
    _textAlign = newValue;
    notifyListeners();
  }

  get textAlign => _textAlign ?? TextAlign.start;

  //------------------------------------------------------------------------------------------------
  // Text overflow
  //------------------------------------------------------------------------------------------------
  TextOverflow _overflow;

  set overflow(TextOverflow newValue) {
    _overflow = newValue;
    notifyListeners();
  }

  get overflow => _overflow ?? (_singleLine ?? false ? TextOverflow.ellipsis : null);

  //------------------------------------------------------------------------------------------------
  // Text overflow
  //------------------------------------------------------------------------------------------------
  int _maxLines;

  set maxLines(int newValue) {
    _maxLines = newValue;
    notifyListeners();
  }

  get maxLines => _maxLines;

  //------------------------------------------------------------------------------------------------
  // Padding
  //------------------------------------------------------------------------------------------------
  EdgeInsetsGeometry _padding;

  set padding(EdgeInsetsGeometry newValue) {
    _padding = newValue;
    notifyListeners();
  }

  get padding => _padding;

  //------------------------------------------------------------------------------------------------
  // Text tap listener
  //------------------------------------------------------------------------------------------------
  OnTapListener _onTap;

  set onTap(OnTapListener newValue) {
    _onTap = newValue;
    notifyListeners();
  }

  get onTap => _onTap;

  //------------------------------------------------------------------------------------------------
  // Text tap border radius
  //------------------------------------------------------------------------------------------------
  BorderRadius _tapEffectRadius;

  set tapEffectRadius(BorderRadius newValue) {
    _tapEffectRadius = newValue;
    notifyListeners();
  }

  get tapEffectRadius => _tapEffectRadius;

  //------------------------------------------------------------------------------------------------
  // View Alignment
  //------------------------------------------------------------------------------------------------
  Alignment _alignment;

  set alignment(Alignment newValue) {
    _alignment = newValue;
    notifyListeners();
  }

  get alignment => _alignment;

  //------------------------------------------------------------------------------------------------
  // Expanded
  //------------------------------------------------------------------------------------------------
  int _flex;

  set flex(int newValue) {
    _flex = newValue;
    notifyListeners();
  }

  get flex => _flex;
}
