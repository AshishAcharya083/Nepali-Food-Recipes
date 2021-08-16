import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nepali_food_recipes/helpers/login_checker.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/helpers/screen_size.dart';
import 'package:nepali_food_recipes/screens/on_boarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Lottie.asset(
            'images/splash_final.json',
            fit: BoxFit.cover,
            controller: controller,
            onLoaded: (composition) {
              print("loaded");

              controller
                ..duration = composition.duration
                ..forward();
              goToOnBoarding(composition.duration);
            },
          ),
        ),
      ),
    );
  }

  goToOnBoarding(Duration duration) async {
    Future.delayed(
      duration,
      () async {
        // Navigation.changeScreenWithReplacement(context, OnBoardingScreen());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getBool('showOnBoardingScreen') ?? true) {
          Navigation.changeScreenWithReplacement(context, OnBoardingScreen());
        } else
          Navigation.changeScreenWithReplacement(context, LogInChecker());
      },
    );
  }
}
