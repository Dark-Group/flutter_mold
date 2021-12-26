import 'package:flutter/material.dart';

typedef OnTapListener = void Function();

abstract class MyWidget extends StatelessWidget {
  Widget onTapWidget(
    Widget widget, {
    OnTapListener onTapListener,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    if (onTapListener != null) {
      widget = Material(
        color: Colors.transparent,
        child: InkWell(
          child: widget,
          borderRadius: borderRadius,
          onTap: () {
            // Vibration.hasVibrator().then((value) {
            //   Vibration.vibrate(duration: 10, amplitude: 10);
            // });
            onTapListener?.call();
          },
        ),
      );
    }
    return widget;
  }

  Widget onPaddingWidget(Widget widget, {EdgeInsetsGeometry padding}) {
    if (padding != null) {
      widget = new Padding(
        padding: padding,
        child: widget,
      );
    }
    return widget;
  }

  Widget onExpandedWidget(Widget widget, {int flex}) {
    if ((flex ?? 0) >= 1) {
      widget = Expanded(
        flex: flex,
        child: widget,
      );
    }
    return widget;
  }

  Widget onAlignment(Widget widget, {Alignment alignment}) {
    if (alignment != null) {
      widget = Align(child: widget, alignment: alignment);
    }
    return widget;
  }
}
