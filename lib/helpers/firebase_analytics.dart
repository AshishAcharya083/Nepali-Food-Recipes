import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class Analytics {
  FirebaseAnalytics? analytics;
  FirebaseAnalyticsObserver? observer;

  Analytics({this.analytics, this.observer});

  Future<void> sendAnalyticsEvent() {
    analytics!.logEvent(name: 'test_event', parameters: <String, dynamic>{
      'name': 'Ashish Acharya',
      'roll number': '05',
    });
    print('ANALYTICS log event send ');
    return Future.value();
  }
}
