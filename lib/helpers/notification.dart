import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nepali_food_recipes/helpers/login_checker.dart';
import 'package:nepali_food_recipes/helpers/navigation.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BuildContext? context;
  NotificationService([this.context]);

  Future<void> init() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void cancelAllNotification() async {
    await flutterLocalNotificationsPlugin
        .cancelAll()
        .whenComplete(() => print('All notification cancelled'));
  }

  Future showNotification(String data) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        '1',
        'test',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin
          .periodicallyShow(0, 'Recipe of the week', 'Click to open the app',
              RepeatInterval.daily, platformChannelSpecifics,
              payload: 'item x')
          .whenComplete(() => print('Notification scheduled'));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future onSelectNotification(String? payload) async {
    debugPrint('NOTIFICATION clicked');
    print('Notification clicked');
    Navigation.changeScreenWithReplacement(this.context!, LogInChecker());
  }
}
