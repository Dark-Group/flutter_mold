import 'package:flutter/material.dart';

class ContainerElevation extends StatelessWidget {
  final Widget childWidget;
  BorderRadius borderRadius;

  Color borderColor;
  Color backgroundColor;

  double elevation;

  double width;
  double height;
  EdgeInsetsGeometry margin;
  EdgeInsetsGeometry padding;

  VoidCallback onClick;

  ContainerElevation(this.childWidget,
      {BorderRadius borderRadius,
      Color borderColor,
      Color backgroundColor,
      double elevation,
      double width,
      double height,
      EdgeInsetsGeometry margin,
      EdgeInsetsGeometry padding,
      this.onClick,
      Key key})
      : super(key: key) {
    this.borderRadius = borderRadius;
    this.borderColor = borderColor ?? Colors.transparent;
    this.backgroundColor = backgroundColor ?? Colors.white;
    this.elevation = elevation;
    this.width = width;
    this.height = height;
    this.margin = margin;
    this.padding = padding;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BoxShadow(
      color: Colors.black26,
      offset: Offset(0, 1),
      blurRadius: elevation ?? 5,
    );

    final boxDecoration = BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: this.borderRadius,
        color: backgroundColor,
        boxShadow: [borderRadius]);

    Widget childWidget = this.childWidget;
    if (padding != null) {
      childWidget = Padding(child: childWidget, padding: this.padding);
    }
    if (onClick != null) {
      childWidget = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: this.borderRadius,
          child: childWidget,
          onTap: onClick,
        ),
      );
    }
    return Container(
        width: this.width,
        height: this.height,
        margin: this.margin,
        decoration: boxDecoration,
        child: childWidget);
  }
}
