import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';

class CustomAlertDialog {
  BuildContext? context;
  CustomAlertDialog(this.context);
  Widget alertDialogWithImage(
      {String titleString = 'Upload Success',
      bool showButton = true,
      String imagePath = 'images/party.png',
      String descriptionText = "Your Recipe is submitted to Admin,"}) {
    return AlertDialog(
      title: Text(titleString,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: kLightGreenColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: AssetImage(imagePath),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              descriptionText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Dosis-Bold',
              ),
            ),
          ),
          showButton
              ? TextButton(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: kLightGreenColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Back to Home',
                        style: kFormHeadingStyle.copyWith(color: Colors.yellow),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        this.context!,
                        MaterialPageRoute(
                          builder: (context) => NavBarController(),
                        ),
                        (route) => false);
                    // Navigation.changeScreen(context, Home());
                  },
                )
              : Container()
        ],
      ),
    );
  }
}
