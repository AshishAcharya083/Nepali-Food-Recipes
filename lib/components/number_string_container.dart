import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

Widget numberStringContainer(int num, String title) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(text: '$num\n', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: title, style: TextStyle(color: kSecondaryTextColor)),
      ],
    ),
  );
}
