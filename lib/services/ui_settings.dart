import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';

class UISettings {
  //This method disables taking ss and srec.
  static Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      primaryColor: isDarkTheme ? Colors.white : Colors.indigo,
      //Used in bottom navigation, back button
      primaryColorLight: isDarkTheme ? Colors.white : const Color(0xFF212323),
      //Used in circle avatar of logo
      primaryColorDark: isDarkTheme ? Colors.indigo : Colors.blue[200],
      //appBar theme
      appBarTheme: AppBarTheme(
        //Changes the color of icons on AppBars
        iconTheme: IconThemeData(
          color: isDarkTheme ? Colors.white : const Color(0xFF212323),
        ),
        //App bar color
        backgroundColor: isDarkTheme ? const Color(0xFF212323) : Colors.white,
        //App bar title text style
        titleTextStyle: GoogleFonts.raleway(
          color: isDarkTheme ? Colors.white : const Color(0xFF212323),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      //Progress bar theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: Colors.indigo,
        color: isDarkTheme ? Colors.grey[850] : Colors.white,
      ),
      primaryTextTheme: TextTheme(
        headline1: GoogleFonts.raleway(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
        //Headline for song title in song page
        headline2: GoogleFonts.lato(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontSize: 20,
        ),
        //Heading for playlist pages
        headline3: GoogleFonts.raleway(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        //Used in form page heading: Suggest us some songs
        headline4: GoogleFonts.raleway(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        //Used in smaller heading: in form page below suggest songs
        headline5: GoogleFonts.raleway(
          fontSize: 14,
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        //Used in button texts
        headline6: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        //Used as title text for all list tiles.
        bodyLarge: GoogleFonts.raleway(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
        //Used in Lyrics widget
        bodyMedium: GoogleFonts.raleway(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        //Used in: upload lyrics image, no internet avaliable, songs loading.
        subtitle2: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }
}
