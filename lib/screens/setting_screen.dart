import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/components/snack_bar.dart';
import 'package:nepali_food_recipes/constants.dart';
import 'package:nepali_food_recipes/helpers/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool? toggleButton = true;

  void getTogglePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      toggleButton = prefs.getBool('notification') ?? true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTogglePrefs();
  }

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
              toggleButton!
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: toggleButton! ? Colors.red : kPrimaryColor,
            ),
            trailing: Switch(
              activeColor: kPrimaryColor,
              activeTrackColor: Colors.red,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: kGreyColor,
              value: toggleButton!,
              onChanged: (b) async {
                showSnackBar(
                    'Notification ${b ? 'Enabled' : 'Disabled'}',
                    context,
                    b
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined);

                setState(() {
                  toggleButton = b;
                });
                print(b);
                if (b) {
                  await NotificationService()
                      .showNotification('Try this new Recipe');
                } else if (!b) {
                  NotificationService().cancelAllNotification();
                }
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('notification', toggleButton!);
              },
            ),
          ),

          /// button for notification testing onclick
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: InkWell(
          //     onTap: () async {
          //       await NotificationService()
          //           .showNotification('Try this new recipes');
          //     },
          //     child: FlatButtonWithText(
          //       text: 'Send me a Notification',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
