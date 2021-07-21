import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';

class AuthProvider with ChangeNotifier {
  User? user;
  bool isLoggedIn = false;
  bool isAdmin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void signInWithGoogle(
      String email, String password, BuildContext context) async {
    print('sign in with google called');
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (_auth.currentUser != null)
          Navigation.changeScreenWithReplacement(context, NavBarController());
      });
    } catch (e) {
      print(e);
    }
  }
}
