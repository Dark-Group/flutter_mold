import 'package:flutter_mold/variable/variable.dart';

abstract class TextValue implements Variable {
  String getText();

  void setText(String text);
}
