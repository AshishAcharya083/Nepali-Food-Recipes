import 'package:flutter/material.dart';

class Navigation {
  static Future changeScreen(BuildContext context, Widget screen) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => screen));
  }
}
