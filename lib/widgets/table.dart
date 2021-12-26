import 'package:flutter/material.dart';
import 'package:flutter_mold/widgets/widget.dart';

enum ViewType { vertical, horizontal, gridCount }

// ignore: must_be_immutable
class MyTable extends MyWidget {
  static BorderRadius borderRadiusOnly(
      {double topLeft = 0.0, double topRight = 0.0, double bottomLeft = 0.0, double bottomRight = 0.0}) {
    final topLeftRadius = Radius.circular(topLeft);
    final topRightRadius = Radius.circular(topRight);
    final bottomLeftRadius = Radius.circular(bottomLeft);
    final bottomRightRadius = Radius.circular(bottomRight);
    return BorderRadius.only(
        topLeft: topLeftRadius, topRight: topRightRadius, bottomLeft: bottomLeftRadius, bottomRight: bottomRightRadius);
  }

  static BorderRadius borderRadiusAll(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  factory MyTable.vertical(
    List<Widget> children, {
    double width,
    double height,
    int flex,
    VoidCallback onTapCallback,
    BorderRadius borderRadius = BorderRadius.zero,
    Color borderColor,
    double elevation = 0.0,
    EdgeInsetsGeometry margin,
    EdgeInsetsGeometry padding,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    Color background,
    Color elevationColor = Colors.black26,
    bool wrap = false,
  }) {
    return MyTable(
      children,
      width: width,
      height: height,
      flex: flex,
      onTapCallback: onTapCallback,
      borderRadius: borderRadius,
      borderColor: borderColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      orientation: ViewType.vertical,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      background: background,
      elevationColor: elevationColor,
      wrap: wrap,
    );
  }

  factory MyTable.horizontal(
    List<Widget> children, {
    double width,
    double height,
    int flex,
    VoidCallback onTapCallback,
    BorderRadius borderRadius = BorderRadius.zero,
    Color borderColor,
    double elevation = 0.0,
    EdgeInsetsGeometry margin,
    EdgeInsetsGeometry padding,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    Color background,
    Color elevationColor = Colors.black26,
    bool wrap = false,
  }) {
    return MyTable(
      children,
      width: width,
      height: height,
      flex: flex,
      onTapCallback: onTapCallback,
      borderRadius: borderRadius,
      borderColor: borderColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      orientation: ViewType.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      background: background,
      elevationColor: elevationColor,
      wrap: wrap,
    );
  }

  factory MyTable.gridCount(
    int crossAxisCount,
    List<Widget> children, {
    double width,
    double height,
    int flex,
    VoidCallback onTapCallback,
    BorderRadius borderRadius = BorderRadius.zero,
    Color borderColor,
    double elevation = 0.0,
    EdgeInsetsGeometry margin,
    EdgeInsetsGeometry padding,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    Color background,
    Color elevationColor = Colors.black26,
    bool wrap = false,
  }) {
    return MyTable(
      children,
      width: width,
      height: height,
      flex: flex,
      onTapCallback: onTapCallback,
      borderRadius: borderRadius,
      borderColor: borderColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      orientation: ViewType.gridCount,
      crossAxisCount: crossAxisCount,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      background: background,
      elevationColor: elevationColor,
      wrap: wrap,
    );
  }

  double _width;
  double _height;
  int _flex;
  bool _wrap;

  VoidCallback _onTapCallback;

  BorderRadius _borderRadius;
  Color _borderColor;
  double _elevation;

  EdgeInsetsGeometry _margin;
  EdgeInsetsGeometry _padding;

  List<Widget> _children;
  ViewType _orientation;
  int _crossAxisCount;

  MainAxisAlignment _mainAxisAlignment;
  MainAxisSize _mainAxisSize;

  CrossAxisAlignment _crossAxisAlignment;

  Color _background;
  Color _elevationColor;

  MyTable(
    List<Widget> children, {
    double width,
    double height,
    int flex,
    VoidCallback onTapCallback,
    BorderRadius borderRadius = BorderRadius.zero,
    Color borderColor,
    double elevation = 0.0,
    EdgeInsetsGeometry margin,
    EdgeInsetsGeometry padding,
    ViewType orientation,
    int crossAxisCount,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    Color background,
    Color elevationColor = Colors.black26,
    bool wrap = false,
  }) {
    this._width = width;
    this._height = height;
    this._flex = flex;
    this._wrap = wrap;

    this._onTapCallback = onTapCallback;

    this._borderRadius = borderRadius;
    this._borderColor = borderColor;
    this._elevation = elevation;

    this._margin = margin;
    this._padding = padding;

    this._children = children;
    this._orientation = orientation;
    this._crossAxisCount = crossAxisCount;

    this._mainAxisAlignment = mainAxisAlignment;
    this._mainAxisSize = mainAxisSize;

    this._crossAxisAlignment = crossAxisAlignment;

    this._background = background;
    this._elevationColor = elevationColor;
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (_orientation == ViewType.vertical) {
      if (this._wrap) {
        widget = Wrap(
          direction: Axis.vertical,
          children: this._children,
        );
      } else {
        widget = Column(
          mainAxisAlignment: this._mainAxisAlignment,
          mainAxisSize: this._mainAxisSize,
          crossAxisAlignment: this._crossAxisAlignment,
          children: this._children,
        );
      }
    } else if (_orientation == ViewType.horizontal) {
      if (this._wrap) {
        widget = Wrap(
          direction: Axis.horizontal,
          children: this._children,
        );
      } else {
        widget = Row(
          mainAxisAlignment: this._mainAxisAlignment,
          mainAxisSize: this._mainAxisSize,
          crossAxisAlignment: this._crossAxisAlignment,
          children: this._children,
        );
      }
    } else if (_orientation == ViewType.gridCount) {
      widget = GridView.count(
        crossAxisCount: _crossAxisCount,
        children: this._children,
      );
    } else {
      widget = Stack(
        children: this._children,
      );
    }

    if (_padding != null) {
      widget = Padding(child: widget, padding: _padding);
    }

    widget = onTapWidget(widget, onTapListener: _onTapCallback, borderRadius: _borderRadius);

    List<BoxShadow> boxShadow = [];
    bool hasElevation = _elevation != null && _elevation > 0.0;
    if (hasElevation) {
      boxShadow.add(BoxShadow(
        color: _elevationColor,
        offset: Offset(0, 1),
        blurRadius: _elevation,
      ));
    }

    final border = _borderColor == null ? null : Border.all(color: _borderColor);
    final decorator = BoxDecoration(
      border: border,
      borderRadius: _borderRadius,
      color: _background,
      boxShadow: boxShadow,
    );

    widget = Container(
      width: this._width,
      height: this._height,
      child: widget,
      decoration: decorator,
    );

    if (_margin != null) {
      widget = Padding(child: widget, padding: _margin);
    }

    if (_flex != null) {
      widget = Expanded(child: widget, flex: _flex);
    }

    return widget;
  }
}
