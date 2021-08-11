import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/bottom_navigation.dart';
import 'package:nepali_food_recipes/screens/food_list.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/profile.dart';
import 'package:nepali_food_recipes/screens/sign_in_screen.dart';
import 'package:nepali_food_recipes/screens/recipe_form.dart';
import 'package:nepali_food_recipes/helpers/notification.dart';

class NavBarController extends StatefulWidget {
  @override
  _NavBarControllerState createState() => _NavBarControllerState();
}

class _NavBarControllerState extends State<NavBarController> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> body = [
    HomePage(),
    RecipeForm(),
    ListScreen(),
    Profile(),
    // SignUpScreen(),
  ];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        onSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
