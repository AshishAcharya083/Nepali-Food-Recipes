import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/number_string_container.dart';
import 'package:nepali_food_recipes/components/user.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Info(
                  imageURL: authProvider.auth.currentUser!.photoURL!,
                  email: authProvider.auth.currentUser!.email!,
                  name: authProvider.auth.currentUser!.displayName!,
                ),
                kFixedSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    numberStringContainer(32, 'Recipes'),
                    numberStringContainer(782, 'following'),
                    numberStringContainer(123, 'followers'),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
