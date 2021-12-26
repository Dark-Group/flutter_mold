import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class MyIcon extends StatelessWidget {
  factory MyIcon.icon(IconData icon,
      {double size,
      int flex,
      Color color,
      EdgeInsetsGeometry padding,
      EdgeInsetsGeometry margin,
      Alignment alignment,
      bool visible,
      VoidCallback onTap}) {
    return MyIcon(
      icon: icon,
      size: size,
      flex: flex,
      color: color,
      padding: padding,
      alignment: alignment,
      visible: visible,
      onTap: onTap,
    );
  }

  factory MyIcon.svg(String svg,
      {double size,
      int flex,
      Color color,
      EdgeInsetsGeometry padding,
      EdgeInsetsGeometry margin,
      Alignment alignment,
      bool visible = true,
      VoidCallback onTap}) {
    return MyIcon(
      svg: svg,
      size: size,
      flex: flex,
      color: color,
      padding: padding,
      margin: margin,
      alignment: alignment,
      visible: visible,
      onTap: onTap,
    );
  }

  IconData _icon;
  String _svg;
  double _size;
  int _flex;

  Color _color;

  EdgeInsetsGeometry _padding;
  EdgeInsetsGeometry _margin;
  Alignment _alignment;

  bool _visible;

  VoidCallback _onTap;

  MyIcon(
      {IconData icon,
      String svg,
      double size,
      int flex,
      Color color,
      EdgeInsetsGeometry padding,
      EdgeInsetsGeometry margin,
      Alignment alignment,
      bool visible = true,
      VoidCallback onTap}) {
    this._icon = icon;
    this._svg = svg;
    this._size = size;
    this._flex = flex;
    this._color = color;
    this._padding = padding;
    this._margin = margin;
    this._alignment = alignment;
    this._visible = visible;
    this._onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = null;
    if (_icon != null) {
      widget = Icon(_icon, size: _size, color: _color);
    } else if (_svg != null) {
      widget = SvgPicture.asset(_svg, color: _color, width: _size, height: _size);
    }

    if (_padding != null) {
      widget = Padding(child: widget, padding: _padding);
    }

    if (_onTap != null) {
      widget = Material(
        child: InkWell(
          child: widget,
          onTap: _onTap,
          radius: 20,
          borderRadius: BorderRadius.circular(100),
        ),
        color: Colors.transparent,
      );
    }

    if (_margin != null) {
      widget = Padding(child: widget, padding: _margin);
    }

    if (_alignment != null) {
      widget = Align(child: widget, alignment: _alignment);
    }

    if (_flex != null) {
      widget = Expanded(child: widget, flex: _flex);
    }

    if (_visible != null && !_visible) {
      widget = Visibility(child: widget, visible: _visible);
    }

    return widget;
  }
}
