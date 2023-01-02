import 'package:flutter/material.dart';
import 'package:flutter_mold/widgets/bloc/edittext_bloc.dart';
import 'package:flutter_mold/widgets/widget.dart';
import 'package:provider/provider.dart';

class GEditText extends MyWidget {
  final GEditTextBloc block = GEditTextBloc();
  final bool? enable;
  final Color? fillColor;

  GEditText({
    double? width,
    double? height,
    String? text,
    TextStyle? style,
    bool? enableObscure,
    InputDecoration? decoration,
    String? hintText,
    TextStyle? hintStyle,
    TextInputType keyboardType = TextInputType.text,
    TextAlign textAlign = TextAlign.left,
    TextAlignVertical textAlignVertical = TextAlignVertical.center,
    int? maxLines = 1,
    int? minLines = 1,
    int? maxLength,
    Widget? prefixIcon,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
    ValueChanged<String>? onChange,
    EdgeInsetsGeometry? padding,
    Alignment? alignment,
    int? flex,
    this.enable = true,
    this.fillColor,
  }) {
    block.width = width;
    block.height = height;
    block.text = text;
    block.style = style;
    block.enableObscure = enableObscure;
    block.decoration = decoration;
    block.hintText = hintText;
    block.hintStyle = hintStyle;
    block.keyboardType = keyboardType;
    block.textAlign = textAlign;
    block.textAlignVertical = textAlignVertical;
    block.maxLines = maxLines;
    block.minLines = minLines;
    block.maxLength = maxLength;
    block.prefixIcon = prefixIcon;
    block.suffixIcon = suffixIcon;
    block.validator = validator;
    block.controller = controller;
    block.onChange = onChange;
    block.padding = padding;
    block.alignment = alignment;
    block.flex = flex;
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
    return ChangeNotifierProvider<GEditTextBloc>.value(
      value: block,
      child: Consumer<GEditTextBloc>(
        builder: (context, model, child) => _buildWidget(model),
      ),
    );
  }

  Widget _buildWidget(GEditTextBloc bloc) {
    Widget widget = _buildEditText(bloc);

    widget = onPaddingWidget(widget, padding: bloc.padding);

    widget = onAlignment(widget, alignment: block.alignment);

    widget = onExpandedWidget(widget, flex: bloc.flex);

    return SizedBox(
      width: block.width,
      height: block.height,
      child: widget,
    );
  }

  Widget _buildEditText(GEditTextBloc bloc) {
    var decorator = block.decoration ?? getDecorator(bloc);

    return TextFormField(
      initialValue: block.text,
      controller: block.controller,
      validator: block.validator,
      style: block.style,
      obscureText: block.enableObscure,
      textAlign: block.textAlign,
      textAlignVertical: block.textAlignVertical,
      maxLines: block.maxLines,
      minLines: block.minLines,
      maxLength: block.maxLength,
      decoration: decorator,
      onChanged: block.onChange,
    );
  }

  InputDecoration getDecorator(GEditTextBloc bloc) {
    Widget? suffixIcon = block.suffixIcon;
    if (block.keyboardType == TextInputType.visiblePassword) {
      suffixIcon = IconButton(
        icon: Icon(
          block.enableObscure ? Icons.remove_red_eye_rounded : Icons.remove_red_eye_outlined,
          size: 18,
        ),
        onPressed: () => block.switchObscure(),
      );
    }

    return InputDecoration(
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
      hintText: block.hintText,
      hintStyle: block.hintStyle,
      isDense: true,
      contentPadding: const EdgeInsets.all(9),
      prefixIcon: block.prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enable ?? true,
      fillColor: fillColor,
      filled: fillColor != null,
    );
  }
}
