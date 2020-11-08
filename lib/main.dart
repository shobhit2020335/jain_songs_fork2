//Expansion Tile
//Card
//SnackBar (Toast)
//TabBar, TabController, TabView
//Bottom Navigation
//ListView
//Future, async, await, future.then()/.whenComplete()
//connectivity package
//url_launcher package
//flutter share package
//modal progress hud
//SearchBar
//Firebase Firestore
//IndexedStack
//Shared Preferences
//DateTime

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NetworkHelper().changeDate();
  runApp(MainTheme());
}

class MainTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
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
        accentColor: Colors.white,
        textTheme: TextTheme(
          //changes color of expansion tile when closed
          subtitle1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(),
    );
  }
}
