import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:nepali_food_recipes/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoggedIn = false;
  bool isAdmin = false;
  // GoogleAuthCredential? user;
  GoogleSignInAccount? currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signInWithGoogle(
      String email, String password, BuildContext context) async {
    print('sign in with google called');
    try {
      currentUser = await googleSignIn.signIn();
      print('The current user is ${currentUser!.displayName}');
      if (currentUser != null) {
        final googleAuth = await currentUser!.authentication;
        await auth
            .signInWithCredential(GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ))
            .then((value) => {
                  _firestore
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .set({
                    'name': auth.currentUser!.displayName.toString(),
                    'userId': auth.currentUser!.uid,
                  }, SetOptions(merge: true)),
                  Navigation.changeScreenWithReplacement(
                      context, NavBarController())
                });
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void signOut(BuildContext context) async {
    await googleSignIn.disconnect();
    auth.signOut();

    Navigation.changeScreenWithReplacement(context, SignUpScreen());
    notifyListeners();
  }
}
