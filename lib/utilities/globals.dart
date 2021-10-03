import 'package:firebase_auth/firebase_auth.dart';

class Globals {
  static final DateTime startDate = DateTime(2020, 12, 23);
  static const String appURL =
      'https://play.google.com/store/apps/details?id=com.JainDevelopers.jain_songs';
  static late DateTime todayDate;
  static int totalDays = 1;
  static int? fetchedDays = 1;
  static String welcomeMessage = 'Jai Jinendra';
  static int lastSongModifiedTime =
      DateTime(2020, 12, 25, 12).millisecondsSinceEpoch;

  //TODO: update app version for new app.
  static const double appVersion = 1.33;
  static double? fetchedVersion;
  //Anonymous user's variable.
  static UserCredential? userCredential;
}
