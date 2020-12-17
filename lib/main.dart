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
//Search Bar (flappy search bar)
//RichText
//DeviceInfo (Fetches device info)
//flutter_launcher_icon
//firebase_admob
//flutter_windowmanager (disable ss and srec)
//TODO: different ads than banner ads (native ads).
//TODO: facebook ads
//TODO: provider(State management)
//TODO: Audio Player
//TODO: TensorFlow (Recommendations)
//TODO: Mic
//TODO: zoom/size
//TODO: Dark mode
//TODO: youTube miniplayer
//TODO: Karoke

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/uisettings.dart';
import 'ads/ad_manager.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainTheme());
  secureScreen();
  //Initialising AdMob.
  _initAdMob();
}

Future<void> _initAdMob() {
  // TODO: Initialize AdMob SDK
  return FirebaseAdMob.instance.initialize(appId: AdManager().appId);
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
