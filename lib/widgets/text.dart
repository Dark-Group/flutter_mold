import 'package:flutter/material.dart';
import 'package:flutter_mold/widgets/bloc/text_bloc.dart';
import 'package:flutter_mold/widgets/widget.dart';
import 'package:provider/provider.dart';

class MyText extends MyWidget {
  final MyTextBloc block = new MyTextBloc();

  MyText(
    String text, {
    bool? upperCase,
    bool? lowerCase,
    bool? singleLine,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
    EdgeInsetsGeometry? padding,
    OnTapListener? onTap,
    BorderRadius? tapEffectRadius,
    Alignment? alignment,
    int? flex,
    Stream<String>? textStream,
  }) {
    block.text = text;
    block.upperCase = upperCase;
    block.lowerCase = lowerCase;
    block.singleLine = singleLine;
    block.style = style;
    block.textAlign = textAlign;
    block.overflow = textOverflow;
    block.maxLines = maxLines;
    block.padding = padding;
    block.onTap = onTap;
    block.tapEffectRadius = tapEffectRadius;
    block.alignment = alignment;
    block.flex = flex;

    if (textStream != null) {
      textStream.listen((newText) {
        block.text = newText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //this is changed by zarifergashev

    //@Problem
    //ChangeNotifierProvider not updating the UI that is why i change

    //@Solution
    //If you already have an instance of ChangeNotifier and want to expose it,
    // you should use ChangeNotifierProvider.value instead of the default constructor.
    //Failing to do so may dispose the ChangeNotifier when it is still in use.
    //you can read more complete this link: https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html
    return new ChangeNotifierProvider<MyTextBloc>.value(
      value: block,
      child: new Consumer<MyTextBloc>(builder: (context, model, child) => _buildWidget(model)),
    );
  }

  Widget _buildWidget(MyTextBloc bloc) {
    Widget widget = _buildText(bloc);

    widget = onPaddingWidget(widget, padding: bloc.padding);

    widget = onTapWidget(
      widget,
      onTapListener: bloc.onTap,
      borderRadius: bloc.tapEffectRadius,
    );

    widget = onAlignment(widget, alignment: block.alignment);

    widget = onExpandedWidget(widget, flex: bloc.flex);

    return widget;
  }

  Widget _buildText(MyTextBloc bloc) {
    return Text(
      bloc.text,
      style: bloc.style,
      strutStyle: null,
      textAlign: bloc.textAlign,
      textDirection: null,
      locale: null,
      softWrap: null,
      overflow: bloc.overflow,
      textScaleFactor: null,
      maxLines: bloc.maxLines,
      semanticsLabel: null,
      textWidthBasis: null,
      textHeightBehavior: null,
    );
  }
}
