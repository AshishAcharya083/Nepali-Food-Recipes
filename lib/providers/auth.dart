import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nepali_food_recipes/helpers/login_checker.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/nav_controller.dart';
import 'package:nepali_food_recipes/screens/on_boarding.dart';
import 'package:nepali_food_recipes/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoggedIn = false;
  bool isAdmin = false;
  QueryDocumentSnapshot? currentUserSnapshot;
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
                  isAdminFunction(),
                  _firestore
                      .collection('users')
                      .where('email', isEqualTo: auth.currentUser!.email)
                      .get()
                      .then((value) {
                    if (value.size == 0) {
                      print('new user created');
                      _firestore
                          .collection('users')
                          .doc(auth.currentUser!.uid)
                          .set({
                        'name': auth.currentUser!.displayName.toString(),
                        'userId': auth.currentUser!.uid,
                        'email': auth.currentUser!.email,
                        'recipes': 0,
                        'followers': 0,
                        'following': 0,
                        'photo': auth.currentUser!.photoURL,
                        'saved': [],
                      }, SetOptions(merge: true));
                    }
                  }),
                  Navigation.changeScreenWithReplacement(
                      context, NavBarController())
                });
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void isAdminFunction() {
    print('isAdminFunction called');
    print('the current user email is ${auth.currentUser!.email}');
    _firestore
        .collection('admins')
        .where('email', isEqualTo: auth.currentUser!.email)
        .get()
        .then((value) => {
              if (value.docs.length > 0)
                {isAdmin = true, print('isAdmin = true'), notifyListeners()}
            });
    notifyListeners();
  }

  void signOut(BuildContext context) async {
    print('isAdmin is : $isAdmin');
    print('log out tapped');
    await googleSignIn.disconnect();
    auth.signOut();

    notifyListeners();
    Navigation.changeScreenWithReplacement(context, SignUpScreen());
  }
}
