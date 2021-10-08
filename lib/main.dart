import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/helpers/firebase_analytics.dart';
import 'package:nepali_food_recipes/helpers/notification.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nepali_food_recipes/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    Analytics myAnalytics = Analytics(analytics: analytics, observer: observer);
    myAnalytics.sendAnalyticsEvent();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
          navigatorObservers: <NavigatorObserver>[observer],
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Dosis',
            // accentColor: kPrimaryColor,
            primaryIconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          home: SplashScreen()),
    );
  }
}
