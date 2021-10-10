import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> setIsDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', value);
  }

  static Future<bool> getIsDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('isDarkTheme');
    if (value == null) {
      return true;
    }
    return value;
  }

  static Future<void> setIsAutoplayVideo(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAutoplayVideo', value);
  }

  static Future<bool> getIsAutoplayVideo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('isAutoplayVideo');
    if (value == null) {
      return true;
    }
    return value;
  }

  static Future<void> setIsFirstOpen(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstOpen', value);
  }

  static Future<bool?> getIsFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('isFirstOpen');
    return value;
  }

  static Future<void> setOneSignalPlayerId(String? playerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('playerId', playerId != null ? playerId : 'NA');
  }

  static Future<String?> getOneSignalPlayerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? playerId = prefs.getString('playerId');
    return playerId;
  }

  static Future<void> setIsLiked(String code, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(code, value);
  }

  static Future<bool?> getIsLiked(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(code);
    return value;
  }

  static Future<void> setLastSyncTime(int lastSyncTime) async {
    print('Updating last sync time to: $lastSyncTime');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(
      'lastSyncTime',
      lastSyncTime,
    );
  }

  static Future<int?> getLastSyncTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastSyncTime = prefs.getInt('lastSyncTime');
    return lastSyncTime;
  }
}
