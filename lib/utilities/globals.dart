import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jain_songs/services/shared_prefs.dart';

class Globals {
  //TODO: Make debug mode false when releasing
  static const bool isDebugMode = true;

  static final DateTime startDate = DateTime(2020, 12, 23);
  static late DateTime todayDate;
  static int totalDays = 1;
  static int? fetchedDays = 1;
  static String welcomeMessage = 'Jai Jinendra';
  static int lastSongModifiedTime =
      DateTime(2020, 12, 25, 12).millisecondsSinceEpoch;

  //TODO: update app version for new app.
  static const double appVersion = 2.00;
  static double? fetchedVersion;
  //Anonymous user's variable.
  static UserCredential? userCredential;
  //Used for initializing realtime DB
  static FirebaseApp? firebaseApp;

  //varible which sets whether to autoplay videos/songs or not.
  static bool isVideoAutoPlay = true;
  //Variable which sets whether dark mode is on or off.
  static bool isDarkTheme = true;

  //Set user settings when app is started.
  static Future<void> setGlobals() async {
    isDarkTheme = await SharedPrefs.getIsDarkTheme();
    SharedPrefs.getIsAutoplayVideo().then((value) {
      isVideoAutoPlay = value;
    });
  }

  static String getAppPlayStoreUrl() {
    return 'https://play.google.com/store/apps/details?id=com.JainDevelopers.jain_songs';
  }
}
