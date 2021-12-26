import 'package:flutter/material.dart';
import 'package:flutter_mold/widgets/table.dart';
import 'package:flutter_mold/widgets/text.dart';
import 'package:flutter_mold/widgets/widget.dart';

class GButton extends MyWidget {
  final String text;

  double width;
  double height;

  Color backgroundColor;

  BorderRadius borderRadius;

  EdgeInsetsGeometry margin;
  EdgeInsetsGeometry padding;
  TextAlign textAlign;
  bool upperCase;

  Color textColor;
  double fontSize;

  final OnTapListener onTap;

  GButton(this.text,
      {this.width,
      this.height,
      this.backgroundColor,
      this.borderRadius,
      this.margin,
      this.padding,
      this.textAlign,
      this.textColor,
      this.upperCase,
      this.onTap,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = this.borderRadius ?? BorderRadius.circular(8);

    TextStyle textStyle = TextStyle(
      color: this.textColor,
      fontSize: this.fontSize,
    );

    Widget widget = MyText(
      this.text,
      style: textStyle,
      textAlign: this.textAlign,
      upperCase: this.upperCase,
      alignment: Alignment.center,
    );

    widget = MyTable(
      [widget],
      width: this.width,
      height: this.height,
      borderRadius: borderRadius,
      background: this.backgroundColor,
      margin: this.margin,
      padding: this.padding,
      elevation: 3,
      onTapCallback: onTap,
    );

    return widget;
  }
}
