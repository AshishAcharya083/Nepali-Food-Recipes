import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/number_string_container.dart';
import 'package:nepali_food_recipes/components/user.dart';
import 'package:nepali_food_recipes/constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Info(
                email: 'heroKumar@gmail.com',
                name: 'Ashish Acharya',
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
        ),
      ),
    );
  }
}
