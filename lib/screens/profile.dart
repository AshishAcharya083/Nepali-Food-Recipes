import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/user.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
