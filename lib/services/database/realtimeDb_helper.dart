import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/flutter_list_configured/filters.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';

class RealtimeDbHelper {
  final FirebaseApp? app;
  late FirebaseDatabase database;
  final Trace _traceSync = FirebasePerformance.instance.newTrace('syncDatbase');
  final Trace _traceRealtime =
      FirebasePerformance.instance.newTrace('getSongRealtime');

  RealtimeDbHelper({this.app}) {
    if (app != null) {
      database = FirebaseDatabase(app: this.app);
    }
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

    if (DataBaseController.fromCache == false || isFirstOpen == null) {
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

  Future<bool> changeClicks(SongDetails currentSong) async {
    int todayClicks = currentSong.todayClicks! + 1;
    int totalClicks = currentSong.totalClicks! + 1;

    //Algo for trendPoints
    double avgClicks = totalClicks / Globals.totalDays;
    double nowTrendPoints = todayClicks - avgClicks;
    double trendPointInc = nowTrendPoints - currentSong.trendPoints!;

    if (nowTrendPoints < currentSong.trendPoints!) {
      trendPointInc = 0;
    }
    print('Change clicks');
    try {
      await database
          .reference()
          .child('songs')
          .child(currentSong.code!)
          .update({
        'popularity': ServerValue.increment(1),
        'totalClicks': ServerValue.increment(1),
        'todayClicks': ServerValue.increment(1),
      });
      currentSong.todayClicks = currentSong.todayClicks! + 1;
      currentSong.totalClicks = currentSong.totalClicks! + 1;
      currentSong.popularity = currentSong.popularity! + 1;
      print('Change trendpoints');
      if (trendPointInc > 0) {
        database.reference().child('songs').child(currentSong.code!).update({
          'trendPoints': nowTrendPoints,
        }).then((value) {
          currentSong.trendPoints = currentSong.trendPoints! + trendPointInc;
        });
      }
    } catch (e) {
      print('Error updating clicks or popularity in realtime: $e');
      return false;
    }
    return true;
  }

  Future<bool> changeShare(SongDetails currentSong) async {
    try {
      await database
          .reference()
          .child('songs')
          .child(currentSong.code!)
          .update({
        'share': ServerValue.increment(1),
      });
      currentSong.share = currentSong.share! + 1;
      return true;
    } catch (e) {
      print('Error updating shares in realtime: $e');
      return false;
    }
  }

  Future<bool> changeLikes(
      BuildContext context, SongDetails currentSong, int toAdd) async {
    try {
      await database
          .reference()
          .child('songs')
          .child(currentSong.code!)
          .update({
        'likes': ServerValue.increment(toAdd),
        'popularity': ServerValue.increment(toAdd),
      });
      currentSong.likes = currentSong.likes! + toAdd;
      currentSong.popularity = currentSong.popularity! + toAdd;
      SharedPrefs.setIsLiked(currentSong.code!, currentSong.isLiked);
      return true;
    } catch (e) {
      currentSong.isLiked = !currentSong.isLiked;
      print('Error updating likes in realtime: $e');
      showSimpleToast(context, 'Something went wrong! Please try later.');
      return false;
    }
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
}
