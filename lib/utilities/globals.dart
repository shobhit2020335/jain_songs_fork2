import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jain_songs/services/shared_prefs.dart';

class Globals {
  //TODO: Make debug mode false when releasing
  static const bool isDebugMode = false;

  static final DateTime startDate = DateTime(2020, 12, 23);
  static late DateTime todayDate;
  static int totalDays = 1;
  static int? fetchedDays = 1;
  static String welcomeMessage = 'Jai Jinendra';

  static String pachhkhan_showcase='';
  static int lastSongModifiedTime =
      DateTime(2020, 12, 25, 12).millisecondsSinceEpoch;

  //TODO: update app version for new app.
  static const double appVersion = 2.30;
  static double? fetchedVersion;
  //Anonymous user's variable.
  static UserCredential? userCredential;
  //Used for initializing realtime DB
  static FirebaseApp? firebaseApp;

  //varible which sets whether to autoplay videos/songs or not.
  static bool isVideoAutoPlay = true;
  //Variable which sets whether dark mode is on or off.
  static bool isDarkTheme = false;

  //Set user settings when app is started.
  static Future<void> setGlobals() async {
    isDarkTheme = await SharedPrefs.getIsDarkTheme();
    SharedPrefs.getIsAutoplayVideo().then((value) {
      isVideoAutoPlay = value;
    });
  }

  static String getAppPlayStoreUrl({String appName = "Stavan"}) {
    if (appName == "Almanac Of Wisdom") {
      return 'https://play.google.com/store/apps/details?id=com.JainDevelopers.almanac_of_wisdom';
    }
    return 'https://play.google.com/store/apps/details?id=com.JainDevelopers.jain_songs';
  }

  static Map<int, String> monthMapping = {
    1: 'Janurary',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };
}
