import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nepali_food_recipes/constants.dart';

import 'package:nepali_food_recipes/providers/auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nepali_food_recipes/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  print("THE TOKEN IS");

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class MyApp extends StatelessWidget {
  // static FirebaseAnalytics analytics = FirebaseAnalytics();
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Flutter Demo',
        theme: ThemeData(
          splashColor: kPrimaryColor.withOpacity(0.5),
          highlightColor: kPrimaryColor.withOpacity(0.2),
          fontFamily: 'Dosis',
          // accentColor: kPrimaryColor,
          primaryIconTheme: IconThemeData(
            color: Colors.black,
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: kPrimaryColor),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.unknown,
      };
}
