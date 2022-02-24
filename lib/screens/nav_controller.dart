import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepali_food_recipes/components/bottom_navigation.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:nepali_food_recipes/screens/food_list.dart';
import 'package:nepali_food_recipes/screens/home.dart';
import 'package:nepali_food_recipes/screens/profile.dart';
import 'package:nepali_food_recipes/screens/sign_in_screen.dart';
import 'package:nepali_food_recipes/screens/recipe_form.dart';

import 'package:provider/provider.dart';

import '../constants.dart';

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
    return WillPopScope(
      onWillPop: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Are you sure want to quit?',
              ),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      'Yes',
                      style: kFormHeadingStyle.copyWith(
                          fontSize: 16, color: Colors.red),
                    ),
                    onPressed: () => SystemNavigator.pop()),
                TextButton(
                    child: Text(
                      'cancel',
                      style: kFormHeadingStyle.copyWith(fontSize: 16),
                    ),
                    onPressed: () => Navigator.of(context).pop(false)),
              ],
            );
          },
        );

        return Future.value(true);
      },
      child: Scaffold(
        body: body[_currentIndex],
        bottomNavigationBar: MyBottomNavigationBar(
          onSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
