import 'package:flutter/material.dart';
import 'package:jain_songs/main.dart';
import 'package:jain_songs/services/shared_prefs.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OneSignalNotification {
  Future<void> initOneSignal() async {
    // //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("2c654820-9b1d-42a6-8bad-eb0a1e430d6c");

    //Sets the playerId used for sending notification.
    final status = await OneSignal.shared.getDeviceState();
    final String? playerId = status?.userId;
    // debugPrint('Player Id: $playerId');
    SharedPrefs.setOneSignalPlayerId(playerId);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      debugPrint("Permission for notification: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent result) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      result.complete(result.notification);

      debugPrint('One signal notification clicked now, foreground');
      Map<String, dynamic> dataReceived = result.notification.additionalData!;

      if (dataReceived.containsKey('route') &&
          dataReceived.containsKey('code')) {
        navigatorKey.currentState!
            .pushNamed('/${dataReceived['route']}', arguments: {
          'code': dataReceived['code'],
        });
      } else if (dataReceived.containsKey('deeplink')) {
        Uri uri = Uri.parse(dataReceived['deeplink']);
        launchUrl(uri);
      }
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.
      debugPrint('One signal notification clicked now, background');

      Map<String, dynamic> dataReceived = result.notification.additionalData!;

      if (dataReceived.containsKey('route') &&
          dataReceived.containsKey('code')) {
        navigatorKey.currentState!
            .pushNamed('/${dataReceived['route']}', arguments: {
          'code': dataReceived['code'],
        });
      } else if (dataReceived.containsKey('deeplink')) {
        Uri uri = Uri.parse(dataReceived['deeplink']);
        launchUrl(uri);
      }
    });

    OneSignal.shared.setSubscriptionObserver((changes) async {
      String? playerId = changes.to.userId;
      debugPrint('Player Id got for first time: $playerId');
      SharedPrefs.setOneSignalPlayerId(playerId);
    });
  }
}
