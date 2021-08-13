import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool toggleButton = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Settings',
          style: kFormHeadingStyle,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black),
            ),
            leading: Icon(
              toggleButton ? Icons.notifications_active : Icons.notifications,
              color: toggleButton ? Colors.red : kPrimaryColor,
            ),
            trailing: Switch(
              activeColor: kPrimaryColor,
              activeTrackColor: Colors.red,
              inactiveThumbColor: kPrimaryColor,
              inactiveTrackColor: kPrimaryColor,
              value: toggleButton,
              onChanged: (b) async {
                setState(() {
                  toggleButton = b;
                });
                print(b);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('notification', toggleButton);
              },
            ),
          )
        ],
      ),
    );
  }
}
