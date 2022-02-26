//TODO: Add custom notification sound
//TODO: Add crashlytics for sql.
//TODO: Firebase performance removed. Add it.
//TODO: Priority of tirhtnkar, etc in saearching
//TODO: Detect filter from search and apply it on top
//TODO: Refresh only if user is refreshing after long time
//TODO: Searching does not work properly when refreshing is going on
//TODO: Bug in daily update for syncing song.
//TODO: edit song in lyrics
//TODO: Playlist on home page.
//TODO: suggest edit
//TODO: Consider less points for words smaller than 3 length in searchify.
//TODO: Change playlist colors.
//TODO: On Clicking subtitle open specific playlist of it.
//TODO: Upgrade suggestion to give song which user want to hear. not just mahavir and same
//TODO: Suggester dict for adinth adeshwar, latest new, stavan bhajan
//TODO: in searching consider keyboard
//TODO: fetch song faster by any means or fetch particular song in dynamic link
//TODO: Kannada
//TODO: Find similar words algorithm when searching and search found is empty, see searchEmpty page to get idea
//TODO: Automatically change timer time for dynamic link by taking average user time of opening.
//TODO: User can chat with me.
//TODO: Splash screen
//TODO: Request lyrics
//TODO Playlist banner of RSJ, Vicky, Etc
//TODO: remove special characters in search
//TODO: popular, trending sorting.
//TODO: People can report song if its incorrect.
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
//TODO: getx(State management)
//TODO: Audio Player
//TODO: TensorFlow (Recommendations)
//TODO: zoom/size
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
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
import 'package:jain_songs/services/notification/FirebaseFCMManager.dart';
import 'package:jain_songs/services/provider/darkTheme_provider.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/services/uisettings.dart';
import 'package:jain_songs/song_page.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

//This is used by OneSignal to open page.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Globals.firebaseApp = await Firebase.initializeApp();

  //Firebase Anonymous signIn.
  Globals.userCredential = await FirebaseAuth.instance.signInAnonymously();

  //SQflite initialization
  await SQfliteHelper.initializeSQflite();

  //Persistenace for Firestore
  FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  //Persistence for Realtime Database
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(100000000);

  //Below is flutter local notification
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('icon_notification');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  FirebaseFCMManager.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: FirebaseFCMManager.onLocalNotificationTap);

  //Sets the dark theme and autoplay settings from Shared prefs
  await Globals.setGlobals();

  MobileAds.instance.initialize();

  runApp(const MainTheme());

  //XXX: Comment while debugging.
  UISettings.secureScreen();

  ListFunctions.songsVisited.clear();
}

class MainTheme extends StatefulWidget {
  const MainTheme({Key? key}) : super(key: key);

  @override
  State<MainTheme> createState() => _MainThemeState();
}

class _MainThemeState extends State<MainTheme> {
  //Provider class made in provider folder.
  DarkThemeProvider themeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    bool value = await SharedPrefs.getIsDarkTheme();
    await themeProvider.setIsDarkTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            onGenerateRoute: (settings) {
              if (settings.name == '/song') {
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;

                return MaterialPageRoute(builder: (context) {
                  return SongPage(
                    codeFromDynamicLink: args!['code'],
                    suggestionStreak: '-1' + args['code'],
                    postitionInList: -1,
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
            theme: UISettings.themeData(themeProvider.isDarkTheme, context),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
