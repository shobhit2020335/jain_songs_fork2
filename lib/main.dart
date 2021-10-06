//TODO: Add custom notification sound
//TODO: Bug in daily update for syncing song.
//TODO: edit song in lyrics
//TODO: Playlist on home page.
//TODO: SHared prefs for autoplay and dark mode
//TODO: suggest edit
//TODO: Consider less points for words smaller than 3 length in searchify.
//TODO: Reduce reads by storing time of song insertion or offline lyrics or all songs in one doc.
//TODO: Change playlist colors.
//TODO: On Clicking subtitle open specific playlist of it.
//TODO: Upgrade suggestion to give song which user want to hear. not just mahavir and same.
//TODO: SUggestion data storing is paused
//TODO: Remove debug and check versions.
//TODO: Suggester dict for adinth adeshwar, latest new, stavan bhajan
//TODO: in searching consider keyboard
//TODO: singers, in suggester.
//TODO: fetch song faster by any means or fetch particular song in dynamic link.
//TODO: Store as much data of user you can.
//TODO: Kannada
//TODO: User can chat with me.
//TODO: Song update only before 1AM.
//TODO: Splash screen
//TODO: Request lyrics
//TODO: image suggestion
//TODO Playlist banner of RSJ, Vicky, Etc
//TODO: remove special characters in search
//TODO: Check searchify.
//TODO: popular, trending sorting.
//TODO: People can report song if its incorrect.
//TODO: speaking jai jinendra
//TODO: Streaming audio.
//TODO: Paryushan related images.
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
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/services/notification/FirebaseFCMManager.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/uisettings.dart';
import 'package:jain_songs/song_page.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

//This is used by OneSignal to open page.
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();

  //Firebase Anonymous signIn.
  Globals.userCredential = await FirebaseAuth.instance.signInAnonymously();

  //Persistenace for Firestore
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  //Persistence for Realtime Database
  FirebaseDatabase.instance
      .setPersistenceEnabled(true)
      .then((value) => print('Set persistance: $value'));
  FirebaseDatabase.instance
      .setPersistenceCacheSizeBytes(100000000)
      .then((value) => print('persistance cache size: $value'));

  //Below is flutter local notification
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('icon_notification');
  var initializationSettings =
      new InitializationSettings(android: initializationSettingsAndroid);
  FirebaseFCMManager.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: FirebaseFCMManager.onLocalNotificationTap);

  MobileAds.instance.initialize();
  runApp(MainTheme(app));
  //XXX: Comment while debugging.
  secureScreen();
  //Initialising AdMob.

  ListFunctions.songsVisited.clear();
}

class MainTheme extends StatelessWidget {
  final FirebaseApp app;
  MainTheme(this.app);

  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseApp>(
      create: (context) => this.app,
      child: MaterialApp(
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
          brightness: Globals.isDarkMode ? Brightness.dark : Brightness.light,
          primaryColor: Globals.isDarkMode ? Colors.white : Colors.indigo,
          //Used in bottom navigation, back button
          primaryColorLight:
              Globals.isDarkMode ? Colors.white : Color(0xFF212323),
          //Used in circle avatar of logo
          primaryColorDark:
              Globals.isDarkMode ? Colors.blue[100] : Colors.blue[200],
          //appBar theme
          appBarTheme: AppBarTheme(
            //Changes the color of icons on AppBars
            iconTheme: IconThemeData(
              color: Globals.isDarkMode ? Colors.white : Color(0xFF212323),
            ),
            //App bar color
            backgroundColor:
                Globals.isDarkMode ? Color(0xFF212323) : Colors.white,
            //App bar title text style
            titleTextStyle: GoogleFonts.raleway(
              color: Globals.isDarkMode ? Colors.white : Color(0xFF212323),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          //Progress bar theme
          progressIndicatorTheme: ProgressIndicatorThemeData(
            circularTrackColor: Colors.indigo,
            color: Globals.isDarkMode ? Colors.grey[850] : Colors.white,
          ),
          primaryTextTheme: TextTheme(
            headline1: GoogleFonts.raleway(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            //Headline for song title in song page
            headline2: GoogleFonts.lato(
              color: Globals.isDarkMode ? Colors.white : Colors.black,
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
              color: Globals.isDarkMode ? Colors.white : Colors.black,
            ),
            //Used in smaller heading: in form page below suggest songs
            headline5: GoogleFonts.raleway(
              fontSize: 14,
              color: Globals.isDarkMode ? Colors.white : Colors.black,
            ),
            //Used in button texts
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            //Used as title text for all list tiles.
            bodyText1: GoogleFonts.raleway(
              color: Globals.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
            //Used in Lyrics widget
            bodyText2: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            //Used in: upload lyrics image, no internet avaliable, songs loading.
            subtitle2: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
