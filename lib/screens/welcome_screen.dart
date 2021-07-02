import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/flat_button.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(24),
          children: [
            // SizedBox(
            //   height: ScreenSize.getHeight(context) * 0.08,
            // ),
            Center(
              child: Text(
                'Welcome!',
                style: kFormHeadingStyle,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'Please Enter your account here',
                style: TextStyle(
                    color: kSecondaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration:
                  kTextFieldInputDecoration(hintText: 'Phone Number').copyWith(
                filled: false,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: kPrimaryTextColor,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              decoration:
                  kTextFieldInputDecoration(hintText: 'Password').copyWith(
                filled: false,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: kPrimaryTextColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: kPrimaryTextColor),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: ScreenSize.getWidth(context),
              child: FlatButtonWithText(
                text: 'Sign Up',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Or Sign up with Google',
                style: TextStyle(
                    color: kSecondaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: ScreenSize.getWidth(context),
              child: FlatButtonWithText(
                text: 'Google',
                buttonColor: Color(0xFFFF5842),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
