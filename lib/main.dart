//Bugs
//TODO: Bug in daily update for syncing song.
//TODO: searching bug- after searching and opening song then pressing back then again searching causes bug.

//Logging and crashlytics
//TODO: Add crashlytics for sql
//TODO: Firebase performance removed. Add it.

//Notification, deeplinking and sharing
//TODO: Automatically change timer time for dynamic link by taking average user time of opening.
//TODO: fetch song faster by any means or fetch particular song in dynamic link
//TODO: Add rating and review in app
//TODO: Add custom notification sound

//Searching
//TODO: Priority of tirhtnkar, etc in saearching
//TODO: Detect filter from search and apply it on top
//TODO: Searching does not work properly when refreshing is going on
//TODO: Consider less points for words smaller than 3 length in searchify.
//TODO: in searching consider keyboard
//TODO: Find similar words algorithm when searching and search found is empty, see searchEmpty page to get idea
//TODO: remove special characters in search
//TODO: Jain Dict
//TODO: popular, trending sorting.

//Playlist
//TODO: Playlist on home page.
//TODO: Change playlist colors.
//TODO: On Clicking subtitle open specific playlist of it.
//TODO: Searching inside playlist.
//TODO: user can make playlist

//Suggestions
//TODO: Upgrade suggestion to give song which user want to hear. not just mahavir and same
//TODO: Suggester dict for adinth adeshwar, latest new, stavan bhajan

//Content
//TODO: Kannada

//New Enhancement
//TODO: different ads than interstitial ads (native ads).
//TODO: User can chat with me.
//TODO: edit song lyrics for users
//TODO: Request lyrics
//TODO: Streaming audio.
//TODO: set Rigtone option.
//TODO: Stavan for web
//TODO: Subscripition
//TODO: Audio Player
//TODO: TensorFlow (Recommendations)
//TODO: zoom/size
//TODO: Karaoke
//TODO: IOS

//UI
//TODO: getx(State management)
//TODO: Splash screen
//TODO: Playlist Banner in front page.
//TODO: playlist list to be square

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jain_songs/firebase_options.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
import 'package:jain_songs/services/provider/dark_theme_provider.dart';
import 'package:jain_songs/services/shared_prefs.dart';
import 'package:jain_songs/services/ui_settings.dart';
import 'package:jain_songs/song_page.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

//This is used by OneSignal to open page.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Globals.firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

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

  //Sets the dark theme and autoplay settings from Shared prefs
  await Globals.setGlobals();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MainTheme());

  // if (Globals.isDebugMode == false) {
  //   UISettings.secureScreen();
  // }

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
                final Map<String, dynamic> args =
                    settings.arguments as Map<String, dynamic>;

                return MaterialPageRoute(builder: (context) {
                  return SongPage(
                    codeFromDynamicLink: args['code'],
                    suggestionStreak: "-1 ${args['code']}",
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
