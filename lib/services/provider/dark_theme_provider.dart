import 'package:flutter/material.dart';
import 'package:jain_songs/services/shared_prefs.dart';
import 'package:jain_songs/utilities/globals.dart';

class DarkThemeProvider extends ChangeNotifier {
  //Default dark theme is false.
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  Future<void> setIsDarkTheme(bool value) async {
    _isDarkTheme = value;
    Globals.isDarkTheme = value;
    await SharedPrefs.setIsDarkTheme(value);
    notifyListeners();
  }
}
