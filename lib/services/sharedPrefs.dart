import 'package:shared_preferences/shared_preferences.dart';

Future<void> setisLiked(String code, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(code, value);
}

Future<bool> getisLiked(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool value = prefs.getBool(code);
  return value;
}
