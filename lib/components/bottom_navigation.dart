import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final void Function(int index)? onSelected;
  MyBottomNavigationBar({@required this.onSelected});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
      iconSize: 30,
      containerHeight: 60,
      selectedIndex: _selectedIndex,
      showElevation: false,
      itemCornerRadius: 15,
      curve: Curves.easeIn,
      onItemSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });

        widget.onSelected!(_selectedIndex);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
          activeColor: myPrimaryColor,
          inactiveColor: kSecondaryColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(
            Icons.add_circle,
          ),
          title: Text('Add'),
          activeColor: myPrimaryColor,
          inactiveColor: kSecondaryColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.list),
          title: Text(
            'List ',
          ),
          activeColor: myPrimaryColor,
          inactiveColor: kSecondaryColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
