import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:nepali_food_recipes/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';

class LogInChecker extends StatefulWidget {
  @override
  _LogInCheckerState createState() => _LogInCheckerState();
}

class _LogInCheckerState extends State<LogInChecker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return StreamBuilder<User?>(
            stream: authProvider.auth.authStateChanges(),
            builder: (
              context,
              userSnapshot,
            ) {
              if (userSnapshot.hasData)
                return NavBarController();
              else
                return SignUpScreen();
            });
      }),
    );
  }
}
