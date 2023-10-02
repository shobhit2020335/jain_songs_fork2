import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//These two variables are got when local notification is created.
String? routeFromNotification;
String? codeFromNotification;
late BuildContext contextForNotiTap;

class FirebaseFCMManager {
  //Called when FCM local is tapped.
  static Future onLocalNotificationTap(String? payload) async {
    if (routeFromNotification != null) {
      if (routeFromNotification == 'deeplink') {
        Uri uri = Uri.parse(codeFromNotification!);
        launchUrl(uri);
      } else {
        // debugPrint('Before push named code recieved = $codeFromNotification');
        Navigator.pushNamed(contextForNotiTap, '/$routeFromNotification',
            arguments: {
              'code': codeFromNotification,
            });
      }
    }
  }

// //This creates a channel for notification.
//   static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // name
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high);

//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

  static Future<void> saveFCMToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    debugPrint('FCM token: $fcmToken');
  }

  static Future<String?> getFCMToken() async {
    String? fcmToken = 'null';
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('Error fetching FCM token: $e');
      fcmToken = 'null';
    }
    return fcmToken;
  }

  static Future<void> handleFCMRecieved(BuildContext context) async {
    //FCM code for opening Notification when app is terminated.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('Opening FCM, App was terminated.');

        if (message.data['deeplink'] != null) {
          debugPrint(message.data['deeplink']);
          Uri uri = Uri.parse(message.data['deeplink']);
          launchUrl(uri);
        } else if (message.data['route'] != null) {
          debugPrint(
              'Before push named code recieved = ${message.data['code']}');
          Navigator.pushNamed(context, '/${message.data['route']}', arguments: {
            'code': message.data['code'],
          });
        }
      }
    }).onError((dynamic error, stackTrace) {
      debugPrint(
          '${'Error in terminated FCM. error: $error'}stackTrace: $stackTrace');
    });

    // //FCM code for opening Notification when app is in foreground.
    // FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    //   debugPrint('Opening FCM, App was in foreground.');
    //   RemoteNotification? notification = message!.notification;
    //   AndroidNotification? android = message.notification?.android;

    //   if (notification != null && android != null) {
    //     debugPrint('Making local notification');
    //     flutterLocalNotificationsPlugin
    //         .show(
    //       5,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           channelDescription: channel.description,
    //           icon: 'icon_notification',
    //           sound: const RawResourceAndroidNotificationSound(
    //               'tone_notification'),
    //           importance: Importance.high,
    //           // other properties...
    //         ),
    //       ),
    //       payload: '',
    //     )
    //         .then((value) {
    //       debugPrint('Finish making local notification');

    //       if (message.data['deeplink'] != null) {
    //         routeFromNotification = 'deeplink';
    //         codeFromNotification = message.data['deeplink'];
    //         contextForNotiTap = context;
    //       } else if (message.data['route'] != null) {
    //         contextForNotiTap = context;
    //         routeFromNotification = message.data['route'];
    //         codeFromNotification = message.data['code'];
    //       }
    //     });
    //   }
    // }).onError((error, stackTrace) {
    //   debugPrint('Error in foreground FCM. error: ' +
    //       error +
    //       'stackTrace: ' +
    //       stackTrace.toString());
    // });

    //FCM code for opening Notification when app is in background.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      debugPrint('Opening FCM, App was in background.');

      if (message != null) {
        if (message.data['deeplink'] != null) {
          debugPrint(message.data['deeplink']);
          Uri uri = Uri.parse(message.data['deeplink']);
          launchUrl(uri);
        } else if (message.data['route'] != null) {
          debugPrint(
              'Before push named code recieved = ${message.data['code']}');
          Navigator.pushNamed(context, '/${message.data['route']}', arguments: {
            'code': message.data['code'],
          });
        }
      }
    }).onError((error, stackTrace) {
      debugPrint(
          '${'Error in background FCM. error: $error'}stackTrace: $stackTrace');
    });
  }
}
