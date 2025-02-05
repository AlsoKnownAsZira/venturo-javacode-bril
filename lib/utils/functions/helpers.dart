import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class Helpers {
  static Future<void> logFirebaseAnalytics(
    String screenView,
    String? screenClass,
  ) async {
    if (!kDebugMode) {
      try {
        await FirebaseAnalytics.instance.logScreenView(
          screenName: screenView,
          screenClass: screenClass,
        );
      } on Exception catch (e) {
        Sentry.captureException(e);
      }
    }
  }
}
