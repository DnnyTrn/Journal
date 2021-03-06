import 'package:flutter/material.dart';

class Styles {
  static final lightTheme = ThemeData.light();
  static final darkTheme = ThemeData.dark();
  static final titleStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 40);
  static final dateStyle = TextStyle();
  static final bodyStyle = TextStyle(fontSize: 22);
  static final ratingStyle = TextStyle(fontSize: 14);
  static InputDecoration formFieldDecoration(final String labelText) {
    return InputDecoration(labelText: labelText, border: OutlineInputBorder());
  }
}
