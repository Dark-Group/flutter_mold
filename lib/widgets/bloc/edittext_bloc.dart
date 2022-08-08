import 'package:flutter/material.dart';

class GEditTextBloc extends ChangeNotifier {
  //------------------------------------------------------------------------------------------------
  // width
  //------------------------------------------------------------------------------------------------
  double? _width;

  set width(double? newValue) {
    _width = newValue;
    notifyListeners();
  }

  double? get width => this._width;

  //------------------------------------------------------------------------------------------------
  // height
  //------------------------------------------------------------------------------------------------
  double? _height;

  set height(double? newValue) {
    _height = newValue;
    notifyListeners();
  }

  double? get height => this._height;

  //------------------------------------------------------------------------------------------------
  // String value
  //------------------------------------------------------------------------------------------------
  String? _text;

  set text(String? newValue) {
    _text = newValue;
    notifyListeners();
  }

  String get text => this._text ?? "";

  //------------------------------------------------------------------------------------------------
  // Text style
  //------------------------------------------------------------------------------------------------
  TextStyle? _style;

  set style(TextStyle? newValue) {
    _style = newValue;
    notifyListeners();
  }

  TextStyle get style => _style ?? TextStyle();

  //------------------------------------------------------------------------------------------------
  // input decorator
  //------------------------------------------------------------------------------------------------
  InputDecoration? _decoration;

  set decoration(InputDecoration? newValue) {
    _decoration = newValue;
    notifyListeners();
  }

  InputDecoration? get decoration => _decoration;

  //------------------------------------------------------------------------------------------------
  // Text obscure text for password input type
  //------------------------------------------------------------------------------------------------
  bool? _enableObscure;

  set enableObscure(bool? newValue) {
    _enableObscure = newValue;
    notifyListeners();
  }

  bool get enableObscure => this.keyboardType == TextInputType.visiblePassword && (_enableObscure ?? false);

  void switchObscure() {
    enableObscure = !enableObscure;
  }

  //------------------------------------------------------------------------------------------------
  // hint value
  //------------------------------------------------------------------------------------------------
  String? _hintText;

  set hintText(String? newValue) {
    _hintText = newValue;
    notifyListeners();
  }

  String get hintText => _hintText ?? "";

  //------------------------------------------------------------------------------------------------
  // hint style
  //------------------------------------------------------------------------------------------------
  TextStyle? _hintStyle;

  set hintStyle(TextStyle? newValue) {
    _hintStyle = newValue;
    notifyListeners();
  }

  TextStyle get hintStyle => _hintStyle ?? TextStyle();

  //------------------------------------------------------------------------------------------------
  // Keyboard input type
  //------------------------------------------------------------------------------------------------
  TextInputType? _keyboardType;

  set keyboardType(TextInputType? newValue) {
    _keyboardType = newValue;
    _enableObscure = keyboardType == TextInputType.visiblePassword;
    notifyListeners();
  }

  TextInputType get keyboardType => _keyboardType ?? TextInputType.text;

  //------------------------------------------------------------------------------------------------
  // Text style
  //------------------------------------------------------------------------------------------------
  TextAlign? _textAlign;

  set textAlign(TextAlign newValue) {
    _textAlign = newValue;
    notifyListeners();
  }

  TextAlign get textAlign => _textAlign ?? TextAlign.start;

  //------------------------------------------------------------------------------------------------
  // Text style
  //------------------------------------------------------------------------------------------------
  TextAlignVertical? _textAlignVertical;

  set textAlignVertical(TextAlignVertical? newValue) {
    _textAlignVertical = newValue;
    notifyListeners();
  }

  TextAlignVertical? get textAlignVertical => _textAlignVertical;

  //------------------------------------------------------------------------------------------------
  // Text max lines
  //------------------------------------------------------------------------------------------------
  int? _maxLines;

  set maxLines(int? newValue) {
    _maxLines = newValue;
    notifyListeners();
  }

  int? get maxLines => _maxLines;

  //------------------------------------------------------------------------------------------------
  // prefix icon
  //------------------------------------------------------------------------------------------------
  Widget? _prefixIcon;

  set prefixIcon(Widget? newValue) {
    _prefixIcon = newValue;
    notifyListeners();
  }

  Widget? get prefixIcon => _prefixIcon;

  //------------------------------------------------------------------------------------------------
  // suffix icon
  //------------------------------------------------------------------------------------------------
  Widget? _suffixIcon;

  set suffixIcon(Widget? newValue) {
    _suffixIcon = newValue;
    notifyListeners();
  }

  Widget? get suffixIcon => _suffixIcon;

  //------------------------------------------------------------------------------------------------
  // input text validator
  //------------------------------------------------------------------------------------------------
  FormFieldValidator<String>? _validator;

  set validator(FormFieldValidator<String>? newValue) {
    _validator = newValue;
    notifyListeners();
  }

  FormFieldValidator<String>? get validator => _validator;

  //------------------------------------------------------------------------------------------------
  // controler
  //------------------------------------------------------------------------------------------------
  TextEditingController? _controller;

  set controller(TextEditingController? newValue) {
    _controller = newValue;
    notifyListeners();
  }

  TextEditingController? get controller => _controller ?? TextEditingController(text: this.text);

  //------------------------------------------------------------------------------------------------
  // Padding
  //------------------------------------------------------------------------------------------------
  EdgeInsetsGeometry? _padding;

  set padding(EdgeInsetsGeometry? newValue) {
    _padding = newValue;
    notifyListeners();
  }

  EdgeInsetsGeometry? get padding => _padding;

  //------------------------------------------------------------------------------------------------
  // View Alignment
  //------------------------------------------------------------------------------------------------
  Alignment? _alignment;

  set alignment(Alignment? newValue) {
    _alignment = newValue;
    notifyListeners();
  }

  Alignment? get alignment => _alignment;

  //------------------------------------------------------------------------------------------------
  // Expanded
  //------------------------------------------------------------------------------------------------
  int? _flex;

  set flex(int? newValue) {
    _flex = newValue;
    notifyListeners();
  }

  int? get flex => _flex;
}
