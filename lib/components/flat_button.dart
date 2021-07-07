import 'package:flutter/material.dart';

import '../constants.dart';

class FlatButtonWithText extends StatelessWidget {
  final String? imagePath;
  final String text;
  final Color buttonColor;
  const FlatButtonWithText(
      {this.text = 'Button', this.buttonColor = kPrimaryColor, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imagePath == null
              ? Container()
              : Image(
                  image: AssetImage(imagePath!),
                  height: 20,
                  width: 20,
                ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: kFormHeadingStyle.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
