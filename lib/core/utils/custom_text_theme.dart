import 'package:flutter/material.dart';

abstract class CustomTextStyle {
  static TextStyle black({double? fontSize, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: Colors.black,
    );
  }
}
