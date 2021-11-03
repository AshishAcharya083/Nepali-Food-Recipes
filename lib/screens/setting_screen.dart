import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/flat_button.dart';
import 'package:nepali_food_recipes/components/snack_bar.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/notification.dart';
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
                showSnackBar('Donn\'t worry it will work later', context,
                    Icons.timelapse);
                setState(() {
                  toggleButton = b;
                });
                print(b);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('notification', toggleButton);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                await NotificationService()
                    .showNotification('Try this new recipes');
              },
              child: FlatButtonWithText(
                text: 'Send me a Notification',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
