import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
      title: Image.asset("assets/images/logo2.png", height: 40, width: 40));
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white54),
  );
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(color: Colors.white);
}
