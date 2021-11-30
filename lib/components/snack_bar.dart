import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String snackText, BuildContext context, IconData myIcon) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 1),
    backgroundColor: kPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    content: ListTile(
      leading: Icon(
        myIcon,
        color: kSecondaryColor,
      ),
      title: Text(
        snackText,
        style: kFormHeadingStyle.copyWith(fontSize: 18),
      ),
    ),
  ));
}
