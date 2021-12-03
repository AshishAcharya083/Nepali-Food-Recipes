import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/flat_button.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
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
                'Please Signup to get started',
                style: TextStyle(
                    color: kSecondaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Image(
                height: 300,
                width: 300,
                image: AssetImage('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Continue with',
                style: TextStyle(
                    letterSpacing: 0.8,
                    color: kSecondaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .signInWithGoogle(
                        'imashish083@gmail.com', 'hero123', context);
                // Navigation.changeScreenWithReplacement(
                //     context, NavBarController());
              },
              child: Container(
                padding: EdgeInsets.all(20),
                width: ScreenSize.getWidth(context),
                child: FlatButtonWithText(
                  imagePath: 'images/google.png',
                  text: 'Google',
                  buttonColor: Color(0xFFFF5842),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}
