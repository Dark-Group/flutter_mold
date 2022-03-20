import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/widgets/bloc/edittext_bloc.dart';
import 'package:flutter_mold/widgets/widget.dart';
import 'package:provider/provider.dart';

class GEditText extends MyWidget {
  static String t(String key) => "gwslib:edittext:$key".translate();

  final GEditTextBloc block = new GEditTextBloc();
  final bool enable;
  final Color fillColor;

  GEditText({
    double width,
    double height,
    String text,
    TextStyle style,
    bool enableObscure,
    InputDecoration decoration,
    String hintText,
    TextStyle hintStyle,
    TextInputType keyboardType = TextInputType.text,
    TextAlign textAlign = TextAlign.left,
    TextAlignVertical textAlignVertical = TextAlignVertical.center,
    int maxLines,
    Widget prefixIcon,
    Widget suffixIcon,
    FormFieldValidator<String> validator,
    TextEditingController controller,
    EdgeInsetsGeometry padding,
    Alignment alignment,
    int flex,
    this.enable = true,
    this.fillColor,
  }) {
    this.block.width = width;
    this.block.height = height;
    this.block.text = text;
    this.block.style = style;
    this.block.enableObscure = enableObscure;
    this.block.decoration = decoration;
    this.block.hintText = hintText;
    this.block.hintStyle = hintStyle;
    this.block.keyboardType = keyboardType;
    this.block.textAlign = textAlign;
    this.block.textAlignVertical = textAlignVertical;
    this.block.maxLines = maxLines;
    this.block.prefixIcon = prefixIcon;
    this.block.suffixIcon = suffixIcon;
    this.block.validator = validator;
    this.block.controller = controller;
    this.block.padding = padding;
    this.block.alignment = alignment;
    this.block.flex = flex;
  }

  @override
  Widget build(BuildContext context) {
    //@Problem
    //ChangeNotifierProvider not updating the UI that is why i change

    //@Solution
    //If you already have an instance of ChangeNotifier and want to expose it,
    // you should use ChangeNotifierProvider.value instead of the default constructor.
    //Failing to do so may dispose the ChangeNotifier when it is still in use.
    //you can read more complete this link: https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html
    return new ChangeNotifierProvider<GEditTextBloc>.value(
      value: block,
      child: new Consumer<GEditTextBloc>(builder: (context, model, child) => _buildWidget(model)),
    );
  }

  Widget _buildWidget(GEditTextBloc bloc) {
    Widget widget = _buildEditText(bloc);

    widget = onPaddingWidget(widget, padding: bloc.padding);

    widget = onAlignment(widget, alignment: block.alignment);

    widget = onExpandedWidget(widget, flex: bloc.flex);

    return Container(
      child: widget,
      width: block.width,
      height: block.height,
    );
  }

  Widget _buildEditText(GEditTextBloc bloc) {
    var decorator = block.decoration ?? getDecorator(bloc);

    return TextFormField(
      controller: this.block.controller,
      validator: this.block.validator,
      style: this.block.style,
      obscureText: this.block.enableObscure,
      textAlign: this.block.textAlign,
      textAlignVertical: this.block.textAlignVertical,
      decoration: decorator,
    );
  }

  InputDecoration getDecorator(GEditTextBloc bloc) {
    Widget suffixIcon = this.block.suffixIcon;
    if (this.block.keyboardType == TextInputType.visiblePassword) {
      suffixIcon = IconButton(
        icon: Icon(block.enableObscure ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined),
        onPressed: () => block.switchObscure(),
      );
    }

    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54, width: 0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54, width: 0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54, width: 0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      hintText: this.block.hintText,
      hintStyle: this.block.hintStyle,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      prefixIcon: this.block.prefixIcon,
      suffixIcon: suffixIcon,
      enabled: this.enable,
      fillColor: this.fillColor,
      filled: this.fillColor!=null,
    );
  }
}
