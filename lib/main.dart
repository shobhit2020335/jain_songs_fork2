//TODO: See realtime db for categories.
//TODO: Change firestore caching way.
//TODO: New tirthankar, categories.
//TODO: Jain Dict
//TODO: set Rigtone option.
//TODO: Stavan for web
//TODO: Whatsapp Status
//TODO: searching bug- after searching and opening song then pressing back then again searching causes bug.
//TODO: Disable latest songs for unsbcribed users.
//TODO: Subscripition
//TODO: In App rating
//TODO: starting playback time.
//TODO: Playlist Banner in front page.
//TODO: Searching inside playlists.
//TODO: Add google search.
//TODO: youTube miniplayer- Make beautiful
//TODO: different ads than banner ads (native ads).
//TODO: provider(State management)
//TODO: Audio Player
//TODO: TensorFlow (Recommendations)
//TODO: Mic search
//TODO: zoom/size
//TODO: Dark mode
//TODO: Karaoke
//TODO: playlist list to be square.
//TODO: user can make playlist
//TODO: IOS

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/services/FirebaseFCMManager.dart';
import 'package:jain_songs/services/uisettings.dart';
import 'package:jain_songs/song_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'ads/ad_manager.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Firebase Anonymous signIn.
  userCredential = await FirebaseAuth.instance.signInAnonymously();
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  var initializationSettingsAndroid =
      new AndroidInitializationSettings('icon_notification');
  var initializationSettings =
      new InitializationSettings(android: initializationSettingsAndroid);
  FirebaseFCMManager.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: FirebaseFCMManager.onLocalNotificationTap);

  runApp(MainTheme());
  secureScreen();
  //Initialising AdMob.
  _initAdMob();
  songsVisited.clear();
}

Future<void> _initAdMob() {
  //Initialize AdMob SDK
  return FirebaseAdMob.instance.initialize(appId: AdManager().appId);
}

class MainTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == '/song') {
          final Map<String, dynamic> args = settings.arguments;

          return MaterialPageRoute(builder: (context) {
            return SongPage(
              codeFromDynamicLink: args['code'],
            );
          });
        } else if (settings.name == '/playlist') {
          final Map<String, dynamic> args = settings.arguments;

          return MaterialPageRoute(builder: (context) {
            return PlaylistPage(
              playlistCode: args['code'],
            );
          });
        }
        // assert(false, 'Need to implement ${settings.name}');
        return null;
      },
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
