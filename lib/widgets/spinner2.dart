import 'package:flutter/material.dart';
import 'package:flutter_mold/mold/mold_stateful_widget.dart';
import 'package:flutter_mold/variable/value_spinner.dart';
import 'package:flutter_mold/widgets/icon.dart';
import 'package:flutter_mold/widgets/table.dart';
import 'package:flutter_mold/widgets/text.dart';

class MySpinner2 extends MoldStatefulWidget {
  ValueSpinner _value;
  TextStyle? style;
  EdgeInsets itemPadding = EdgeInsets.all(8);
  EdgeInsets itemMargin = EdgeInsets.all(8);
  BorderRadius itemBorderRadius = MyTable.borderRadiusAll(4);
  bool? withoutBorder;
  bool? textWrapped;
  Widget? dropDownIcon;
  Key? key;

  MySpinner2(
    ValueSpinner value, {
    Key? key,
    EdgeInsets? itemPadding,
    EdgeInsets? itemMargin,
    String? notSelectedText,
    Widget? icon,
    Widget? dropDownIcon,
    TextStyle? style,
    TextStyle? notSelectedTextStyle,
    BorderRadius? itemBorderRadius,
    bool withoutBorder = false,
    bool textWrapped = false,
  }) : _value = value {
    if (itemPadding != null) {
      this.itemPadding = itemPadding;
    }
    if (itemMargin != null) {
      this.itemMargin = itemMargin;
    }

    if (itemBorderRadius != null) {
      this.itemBorderRadius = itemBorderRadius;
    }

    this.style = style ??
        const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          letterSpacing: 0.5,
          fontFamily: "Roboto",
        );

    this.key = key;
    this.dropDownIcon = dropDownIcon;
    this.withoutBorder = withoutBorder;
    this.textWrapped = textWrapped;
  }

  List<DropdownMenuItem<SpinnerOption>> get getMenus {
    return _value.getOptions().map<DropdownMenuItem<SpinnerOption>>((SpinnerOption value) {
      return DropdownMenuItem<SpinnerOption>(
        value: value,
        child: MyText(value.name, style: style),
      );
    }).toList();
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    return AnimatedBuilder(
        animation: _value,
        builder: (_, __) {
          Widget widget = DropdownButtonFormField<SpinnerOption>(
            isExpanded: true,
            items: getMenus,
            onChanged: (code) {
              if (code!.code != _value.getValue().code) {
                _value.setValue(code);
              }
            },
            value: _value.getValue(),
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
            style: TextStyle(fontSize: 14),
            icon: MyIcon.icon(Icons.arrow_drop_down_rounded, size: 16),
          );

          widget = SizedBox(width: null, height: 36, child: widget);

          return widget;
        });
  }
}
