//Expansion Tile
//Card

import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(MainTheme());

class MainTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        accentColor: Color(0xFF18191A),
        appBarTheme: AppBarTheme(
          //Changes the color of icons on AppBars
          iconTheme: IconThemeData(
            color: Color(0xFF212323),
          ),
        ),
        primaryTextTheme: TextTheme(
          //changes color of AppBar title
          headline6: TextStyle(
            fontFamily: 'Pacifico',
            color: Color(0xFF212323),
          ),
        ),
        textTheme: TextTheme(
          //changes color of expansion tile when closed
          subtitle1: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(),
    );
  }
}
