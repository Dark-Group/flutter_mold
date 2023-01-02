import 'package:flutter/material.dart';
import 'package:flutter_mold/common/extensions.dart';
import 'package:flutter_mold/mold/mold_stateful_widget.dart';
import 'package:flutter_mold/variable/value_spinner.dart';
import 'package:flutter_mold/widgets/icon.dart';
import 'package:flutter_mold/widgets/table.dart';
import 'package:flutter_mold/widgets/text.dart';

class MySpinner2 extends MoldStatefulWidget {
  final ValueSpinner value;
  final TextStyle? style;
  final String? title;
  final Color? titleColor;
  final String? errorText;
  final EdgeInsets? margin;

  MySpinner2(this.value, {
    super.key,
    this.title,
    this.titleColor,
    this.errorText,
    this.margin,
    TextStyle? style,
  }) : style = style ??
      const TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        letterSpacing: 0.5,
        fontFamily: "Roboto",
      );

  List<DropdownMenuItem<SpinnerOption>> get getMenus {
    return value.getOptions().map<DropdownMenuItem<SpinnerOption>>((SpinnerOption value) {
      return DropdownMenuItem<SpinnerOption>(
        value: value,
        child: MyText(value.name, style: style),
      );
    }).toList();
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    return AnimatedBuilder(
        animation: value,
        builder: (_, __) {
          Widget widget = DropdownButtonFormField<SpinnerOption>(
            isExpanded: true,
            items: getMenus,
            onChanged: (code) {
              if (code!.code != value
                  .getValue()
                  .code) {
                value.setValue(code);
              }
            },
            value: value.getValue(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              contentPadding: const EdgeInsets.all(8),
              isDense: true,
            ),
            style: style,
            icon: MyIcon.icon(Icons.arrow_drop_down_rounded, size: 16),
          );

          widget = SizedBox(width: null, height: 36, child: widget);

          if (title != null || errorText != null) {
            Widget? wTitle;
            if (title != null) {
              wTitle = MyText(
                title!,
                style: TextStyle(color: titleColor, fontSize: 15),
                padding: const EdgeInsets.only(left: 16, bottom: 8, top: 4),
              );
            }

            Widget? wError;
            if (errorText != null) {
              wError = MyText(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                padding: const EdgeInsets.only(left: 8, top: 4),
              );
            }

            widget = MyTable.vertical([
              if (wTitle != null) wTitle,
              widget,
              if (wError != null) wError,
            ]);
          }

          margin?.let((it) => widget = Padding(padding: margin!, child: widget));
          return widget;
        });
  }
}
