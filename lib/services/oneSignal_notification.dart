import 'package:jain_songs/main.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OneSignalNotification {
  Future<void> initOneSignal() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("2c654820-9b1d-42a6-8bad-eb0a1e430d6c");

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.
      print('One signal notification clicked now');
      Map<String, dynamic> dataReceived = result.notification.additionalData!;

      if (dataReceived.containsKey('route') &&
          dataReceived.containsKey('code')) {
        navigatorKey.currentState!
            .pushNamed('/${dataReceived['route']}', arguments: {
          'code': dataReceived['code'],
        });
      } else if (dataReceived.containsKey('deeplink')) {
        launch(dataReceived['deeplink']);
      }
    });

    OneSignal.shared.setSubscriptionObserver((changes) async {
      String playerId = changes.to.userId!;
      print('Player Id: $playerId');
      SharedPrefs.setOneSignalPlayerId(playerId);
    });
  }
}
