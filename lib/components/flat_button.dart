import 'package:flutter/material.dart';

import '../constants.dart';

class FlatButtonWithText extends StatelessWidget {
  final String text;
  final Color buttonColor;
  const FlatButtonWithText(
      {this.text = 'Button', this.buttonColor = kPrimaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(15)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: kFormHeadingStyle.copyWith(color: Colors.white),
      ),
    );
  }
}
