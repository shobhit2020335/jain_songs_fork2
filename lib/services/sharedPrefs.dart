import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static Future<void> setIsFirstOpen(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstOpen', value);
  }

  static Future<bool> getIsFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('isFirstOpen');
    return value;
  }

  static Future<void> setOneSignalPlayerId(String playerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('playerId', playerId);
  }

  static Future<String> getOneSignalPlayerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String playerId = prefs.getString('playerId');
    return playerId;
  }

  static Future<void> setIsLiked(String code, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(code, value);
  }

  static Future<bool> getIsLiked(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(code);
    return value;
  }
}
