import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:jain_songs/flutter_list_configured/filters.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';

class RealtimeDbHelper {
  final FirebaseApp app;
  late FirebaseDatabase database;
  final Trace _traceSync = FirebasePerformance.instance.newTrace('syncDatbase');
  final Trace _traceRealtime =
      FirebasePerformance.instance.newTrace('getSongRealtime');

  RealtimeDbHelper(this.app) {
    database = FirebaseDatabase(app: this.app);
  }

  //Updates the trend points and resets other data in both firestore and realtime
  //syncs realtime db and firestore
  Future<bool> syncDatabaseWithDailyUpdate() async {
    //Add traces of daily update and sync.
    return false;
  }

  Future<bool> fetchSongs() async {
    print('fetching songs from realtime');
    _traceRealtime.start();
    songList.clear();
    DataSnapshot? songSnapshot;

    bool? isFirstOpen = await SharedPrefs.getIsFirstOpen();

    if (Globals.fromCache == false || isFirstOpen == null) {
      if (isFirstOpen == null) {
        print('First opne null');
        SharedPrefs.setIsFirstOpen(false);
      }
      try {
        songSnapshot = await database.reference().child('songs').get();
      } catch (e) {
        print('Error in fetching');
        print(e);
        return false;
      }
    } else {
      print('From cache');
      songSnapshot = await database.reference().child('songs').once();
    }

    await _readFetchedSongs(songSnapshot!, songList);
    _traceRealtime.stop();
    return true;
  }

  Future<void> _readFetchedSongs(
      DataSnapshot songSnapshot, List<SongDetails?> listToAdd) async {
    Map<String?, dynamic> allSongs =
        Map<String, dynamic>.from(songSnapshot.value);

    allSongs.forEach((key, value) {
      Map<String, dynamic> currentSong = Map<String, dynamic>.from(value);
      String state = currentSong['aaa'].toString();
      state = state.toLowerCase();
      if (state.contains('invalid') != true) {
        SongDetails currentSongDetails = SongDetails(
          album: currentSong['album'].toString(),
          code: currentSong['code'].toString(),
          category: currentSong['category'].toString(),
          genre: currentSong['genre'].toString(),
          gujaratiLyrics: currentSong['gujaratiLyrics'].toString(),
          language: currentSong['language'].toString(),
          lyrics: currentSong['lyrics'].toString(),
          englishLyrics: currentSong['englishLyrics'].toString(),
          songNameEnglish: currentSong['songNameEnglish'].toString(),
          songNameHindi: currentSong['songNameHindi'].toString(),
          originalSong: currentSong['originalSong'].toString(),
          popularity: int.parse(currentSong['popularity'].toString()),
          production: currentSong['production'].toString(),
          searchKeywords: currentSong['searchKeywords'].toString(),
          singer: currentSong['singer'].toString(),
          tirthankar: currentSong['tirthankar'].toString(),
          todayClicks: int.parse(currentSong['todayClicks'].toString()),
          totalClicks: int.parse(currentSong['totalClicks'].toString()),
          trendPoints: double.parse(currentSong['trendPoints'].toString()),
          likes: int.parse(currentSong['likes'].toString()),
          share: int.parse(currentSong['share'].toString()),
          youTubeLink: currentSong['youTubeLink'].toString(),
        );
        SharedPrefs.getIsLiked(currentSong['code'].toString())
            .then((valueIsliked) {
          if (valueIsliked == null) {
            SharedPrefs.setIsLiked(currentSong['code'].toString(), false);
            valueIsliked = false;
          }
          currentSongDetails.isLiked = valueIsliked;
        });

        String songInfo =
            '${currentSongDetails.tirthankar} | ${currentSongDetails.genre} | ${currentSongDetails.singer}';
        currentSongDetails.songInfo = trimSpecialChars(songInfo);
        if (currentSongDetails.songInfo.length == 0) {
          currentSongDetails.songInfo = currentSongDetails.songNameHindi!;
        }
        listToAdd.add(
          currentSongDetails,
        );
      }
    });
  }

  Future<void> overwriteRealtimeDbWithFirestore() async {
    print('Ghusa in overwrite');
    songList.forEach((songDetails) {
      database
          .reference()
          .child('songs')
          .child(songDetails!.code!)
          .set(songDetails.toMap());
    });
  }

  Future<void> fetchSongsDynamicData() async {
    print('Ghusa in fetch dynamic');
    // bool isInternetConnected = await NetworkHelper().checkNetworkConnection();

    database
        .reference()
        .child('userBehaviour')
        .child('filters')
        .get()
        .then((snapshot) {
      print('GOt values of filters: ${snapshot!.key} : ${snapshot.value}');
    });
  }

  Future<void> userSelectedFilters(UserFilters userFilters) async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();
    if (isInternetConnected == false) {
      return;
    }

    //TODO: Comment while debugging.
    final DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference();
    databaseReference
        .child("userBehaviour")
        .child("filters")
        .push()
        .set(userFilters.toMap());
  }

  //Stores the suggestion streak of the user in realtime DB not working so commented.
  // Future<void> storeUserSuggestionStreak(String streak) async {
  //   if (streak == null || streak.trim().length == 0) {
  //     return;
  //   }
  //   bool isInternetConnected = await NetworkHelper().checkNetworkConnection();
  //   if (isInternetConnected == false) {
  //     return;
  //   }

  //   final DatabaseReference databaseReference =
  //       FirebaseDatabase.instance.reference();
  //   String? playerId = await SharedPrefs.getOneSignalPlayerId();
  //   if (playerId == null) {
  //     playerId = await FirebaseFCMManager.getFCMToken();
  //   }
  //   print('Passed this');
  //   databaseReference
  //       .child("userBehaviour")
  //       .child("suggester")
  //       .push()
  //       .set({
  //         '$playerId': '$streak',
  //       })
  //       .then((value) => print('Nikla'))
  //       .onError((error, stackTrace) => print('Error: $error & $stackTrace'));
  // }
}
