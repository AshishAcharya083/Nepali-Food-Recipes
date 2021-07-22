import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:nepali_food_recipes/screens/signup_screen.dart';

class AuthProvider with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoggedIn = false;
  bool isAdmin = false;
  // GoogleAuthCredential? user;
  GoogleSignInAccount? currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithGoogle(
      String email, String password, BuildContext context) async {
    print('sign in with google called');
    try {
      currentUser = await googleSignIn.signIn();
      print('The current user is ${currentUser!.displayName}');
      if (currentUser != null) {
        Navigation.changeScreenWithReplacement(context, NavBarController());
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void signOut(BuildContext context) async {
    await googleSignIn.signOut();
    Navigation.changeScreenWithReplacement(context, SignUpScreen());
    notifyListeners();
  }
}
