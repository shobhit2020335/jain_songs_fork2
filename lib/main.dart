//TODO: Change firestore caching way.
//TODO Add custom notification sound
//TODO: Store as much data of user you can.
//TODO Playlist banner of RSJ, Vicky, Etc
//TODO: see Relatime DB.
//TODO: remove special characters in search
//TODO: CHeck searchify.
//TODO: popular, trending sorting.
//TODO: People can report song if its incorrect.
//TODO: Change UI acc to manu, add stories on first page.
//TODO: speaking jai jinendra
//TODO: Streaming audio.
//TODO: Paryushan related images.
//TODO: New tirthankar, categories.
//TODO: Jain Dict
//TODO: set Rigtone option.
//TODO: Stavan for web
//TODO: Whatsapp Status
//TODO: searching bug- after searching and opening song then pressing back then again searching causes bug.
//TODO: Subscripition
//TODO: In App rating
//TODO: starting playback time in YT player.
//TODO: Playlist Banner in front page.
//TODO: Searching inside playlists.
//TODO: different ads than interstitial ads (native ads).
//TODO: provider(State management)
//TODO: Audio Player
//TODO: TensorFlow (Recommendations)
//TODO: zoom/size
//TODO: Dark mode
//TODO: Karaoke
//TODO: playlist list to be square.
//TODO: user can make playlist
//TODO: IOS

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/services/FirebaseFCMManager.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/services/uisettings.dart';
import 'package:jain_songs/song_page.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'home_page.dart';

//This is used by OneSignal to open page.
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Firebase Anonymous signIn.
  userCredential = await FirebaseAuth.instance.signInAnonymously();
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  //Below is flutter local notification
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('icon_notification');
  var initializationSettings =
      new InitializationSettings(android: initializationSettingsAndroid);
  FirebaseFCMManager.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: FirebaseFCMManager.onLocalNotificationTap);

  MobileAds.instance.initialize();
  runApp(MainTheme());
  //Comment while debugging.
  // secureScreen();
  //Initialising AdMob.

  songsVisited.clear();
}

class MainTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        if (settings.name == '/song') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;

          return MaterialPageRoute(builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                // print('dynamic link onwillpop: -1${args!['code']}');
                FireStoreHelper()
                    .storeSuggesterStreak(args!['code'], '-1${args['code']}');
                return true;
              },
              child: SongPage(
                codeFromDynamicLink: args!['code'],
                suggestionStreak: '-1' + args['code'],
              ),
            );
          });
        } else if (settings.name == '/playlist') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;

          return MaterialPageRoute(builder: (context) {
            return PlaylistPage(
              playlistCode: args!['code'],
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
          headline6: GoogleFonts.raleway(
            color: Color(0xFF212323),
            fontWeight: FontWeight.bold,
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
