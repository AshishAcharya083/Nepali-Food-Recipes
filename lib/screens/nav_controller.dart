import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/bottom_navigation.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/recipe_form.dart';

class NavBarController extends StatefulWidget {
  @override
  _NavBarControllerState createState() => _NavBarControllerState();
}

class _NavBarControllerState extends State<NavBarController> {
  List<Widget> body = [
    Home(),
    RecipeForm(),
    Container(
      child: Center(
        child: Text('another feature'),
      ),
    ),
    Container(
      child: Center(
        child: Text('another feature'),
      ),
    ),
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
