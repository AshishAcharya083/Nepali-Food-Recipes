import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/login_checker.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:nepali_food_recipes/screens/on_boarding.dart';
import 'package:nepali_food_recipes/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nepali_food_recipes/screens/splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Dosis',
            // accentColor: kPrimaryColor,
            primaryIconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          home: SplashScreen()),
    );
  }
}
// Consumer<AuthProvider>(
// builder: (BuildContext context, authProvider, child) {
// if (authProvider.showOnBoarding) {
// return OnBoardingScreen();
// } else {
// return LogInChecker();
// }
// }),
