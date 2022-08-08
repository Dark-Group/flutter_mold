import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_mold/common/lazy_stream.dart';
import 'package:flutter_mold/localization/app_lang.dart';
import 'package:flutter_mold/mold/mold_stateful_widget.dart';
import 'package:flutter_mold/widgets/table.dart';
import 'package:flutter_mold/widgets/text.dart';

typedef SpinnerItemSelect<E> = void Function(E item);

typedef ItemBuilder<E> = Widget Function(E item);

class SpinnerValue {
  List<SpinnerOption> options;
  SpinnerOption? value;

  SpinnerValue(this.options, {this.value}) {
    checkUnique(options);

    if (value != null) {
      int findValuesCount = options.where((element) => element.code == value!.code).length;
      if (findValuesCount == 0) {
        throw Exception("value ${value.toString()} not found exception");
      } else if (findValuesCount != 1) {
        throw Exception("value ${value.toString()} duplicate exception");
      }
    } else {
      if (options.isNotEmpty) {
        this.value = options.first;
      } else {
        throw Exception("options list is empty");
      }
    }
  }

  SpinnerValue.code(this.options, String? selectedCode) {
    checkUnique(options);

    if (selectedCode != null) {
      this.value = options.firstWhere((e) => e.code == selectedCode);
    } else {
      if (options.isNotEmpty) {
        this.value = options.first;
      } else {
        throw Exception("options list is empty");
      }
    }
  }

  SpinnerValue.name(this.options);

  void checkUnique(List<SpinnerOption> options) {
    HashSet<String> keys = new HashSet.identity();
    for (var option in options) {
      if (keys.contains(option.code)) {
        throw Exception("value ${option.toString()} duplicate exception");
      } else {
        keys.add(option.code);
      }
    }
  }
}

class SpinnerOption {
  String code;
  String name;
  Object? tag;

  SpinnerOption(this.code, this.name, {this.tag});

  static final EMTRY = SpinnerOption("", "", tag: null);
  static final NOT_SELECTED = SpinnerOption("#not_select#", "gws:spinner_option:not_selected".translate(), tag: null);

  @override
  String toString() {
    return 'SpinnerOption{code: $code, name: $name, tag: $tag}';
  }
}

class MySpinner extends MoldStatefulWidget {
  SpinnerValue? _value;
  String? _title;
  TextStyle? _titleTextStyle;
  TextStyle? style;
  SpinnerItemSelect<SpinnerOption>? _onItemSelect;
  EdgeInsets titlePadding = EdgeInsets.only(left: 16, right: 16, top: 8);
  EdgeInsets itemPadding = EdgeInsets.only(left: 16, right: 16);
  EdgeInsets itemMargin = EdgeInsets.all(8);
  BorderRadius itemBorderRadius = MyTable.borderRadiusAll(8);
  bool? withoutBorder;
  bool? textWrapped;
  Widget? dropDownIcon;
  Widget? icon;
  Key? key;

  LazyStream<DropdownMenuItem<SpinnerOption>> selectValueSubject = LazyStream();

  MySpinner(SpinnerValue value,
      {Key? key,
      String? title,
      TextStyle? titleTextStyle,
      EdgeInsets? titlePadding,
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
      SpinnerItemSelect<SpinnerOption>? onSelected}) {
    this._value = value;
    this._title = title;
    this._titleTextStyle = titleTextStyle;
    if (titlePadding != null) {
      this.titlePadding = titlePadding;
    }
    if (itemPadding != null) {
      this.itemPadding = itemPadding;
    }
    if (itemMargin != null) {
      this.itemMargin = itemMargin;
    }

    if (itemBorderRadius != null) {
      this.itemBorderRadius = itemBorderRadius;
    }
    this.style = style != null
        ? style
        : TextStyle(color: Colors.black, fontSize: 16.0, letterSpacing: 0.5, fontFamily: "Roboto");

    if (onSelected != null) {
      this._onItemSelect = onSelected;
    }
    this.key = key;
    this.dropDownIcon = dropDownIcon;
    this.icon = icon;
    this.withoutBorder = withoutBorder;
    this.textWrapped = textWrapped;
  }

  void setOnItemSelect(SpinnerItemSelect<SpinnerOption> onItemSelect) {
    this._onItemSelect = onItemSelect;
  }

  List<DropdownMenuItem<SpinnerOption>> menus = [];

  List<DropdownMenuItem<SpinnerOption>> get getMenus {
    if (menus.isNotEmpty == true) {
      return menus;
    } else {
      menus = _value!.options.map<DropdownMenuItem<SpinnerOption>>((SpinnerOption value) {
        return DropdownMenuItem<SpinnerOption>(value: value, child: MyText(value.name, style: style));
      }).toList();
      return menus;
    }
  }

  DropdownMenuItem<SpinnerOption> get selectedMenu =>
      getMenus.firstWhere((element) => element.value!.code == _value!.value?.code, orElse: () => getMenus.first);

  @override
  void onCreate() {
    super.onCreate();
    selectValueSubject.add(selectedMenu);

    this.selectValueSubject.get().listen((value) {
      _onItemSelect?.call(value!.value!);
    });
  }

  @override
  Widget onCreateWidget(BuildContext context) {
    List<Widget> widgets = <Widget>[];

    if (_title?.isNotEmpty == true) {
      widgets.add(MyText(
        _title!,
        style: _titleTextStyle != null
            ? _titleTextStyle
            : TextStyle(color: Colors.black87, fontSize: 10.0, letterSpacing: 1.5, fontFamily: "Roboto"),
        padding: titlePadding,
        upperCase: true,
      ));
    }

    Widget body = StreamBuilder(
      initialData: selectValueSubject.value,
      stream: selectValueSubject.stream,
      builder: (buildContext, snapshot) {
        if (icon != null) {
          return MyTable.horizontal(
            [
              Expanded(child: icon!, flex: 1),
              SizedBox(height: 6),
              Expanded(child: _buildDropDown(selectValueSubject.value!), flex: 9)
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            width: double.infinity,
          );
        } else {
          return _buildDropDown(selectValueSubject.value!);
        }
      },
    );

    if (withoutBorder == true) {
      widgets.add(MyTable(
        [body],
        width: double.infinity,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        background: Colors.white,
        padding: itemPadding,
        margin: itemMargin,
      ));
    } else {
      widgets.add(MyTable(
        [body],
        width: double.infinity,
        mainAxisSize: MainAxisSize.max,
        borderRadius: itemBorderRadius,
        background: Colors.white,
        borderColor: Colors.black38,
        padding: itemPadding,
        margin: itemMargin,
      ));
    }

    return MyTable.vertical(
      widgets,
      mainAxisSize: MainAxisSize.max,
    );
  }

  Widget _buildDropDown(DropdownMenuItem<SpinnerOption> selectValue) {
    Widget result = DropdownButton<SpinnerOption>(
      key: key,
      isExpanded: textWrapped == true,
      value: selectValue.value,
      icon: dropDownIcon != null ? dropDownIcon : Icon(Icons.arrow_drop_down, color: Colors.black38),
      underline: Container(),
      items: getMenus,
      onChanged: (newValue) {
        if (newValue!.code != selectValueSubject.value!.value?.code) {
          _value?.value = newValue;
          final foundValue = getMenus.firstWhere((e) => e.value?.code == newValue.code);
          this.selectValueSubject.add(foundValue);
        }
      },
    );
    return result;
  }

  @override
  void onDestroy() {
    selectValueSubject?.close();
    super.onDestroy();
  }
}
