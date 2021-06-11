import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Dosis',
        accentColor: myPrimaryColor,
        primaryIconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      home: NavBarController(),
    );
  }
}
