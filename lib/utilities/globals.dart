import 'package:firebase_auth/firebase_auth.dart';

class Globals {
  static final DateTime startDate = DateTime(2020, 12, 23);
  static const String appURL =
      'https://play.google.com/store/apps/details?id=com.JainDevelopers.jain_songs';
  static late DateTime todayDate;
  static int totalDays = 1;
  static int? fetchedDays = 1;
  static String welcomeMessage = 'Jai Jinendra';

  //TODO: update app version for new app.
  static const double appVersion = 1.33;
  static double? fetchedVersion;
  //Anonymous user's variable.
  static UserCredential? userCredential;

  //varible which sets whether to autoplay videos/songs or not.
  static bool isVideoAutoPlay = true;
  //Variable which sets whether dark mode is on or off.
  static bool isDarkMode = true;
}
