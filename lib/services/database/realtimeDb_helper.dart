import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/flutter_list_configured/filters.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';

class RealtimeDbHelper {
  final FirebaseApp? app;
  late FirebaseDatabase database;
  final Trace _traceSync = FirebasePerformance.instance.newTrace('syncDatbase');
  final Trace _traceRealtime =
      FirebasePerformance.instance.newTrace('getSongRealtime');

  RealtimeDbHelper(this.app) {
    if (app != null) {
      database = FirebaseDatabase(app: this.app);
    }
  }

  //Updates the trend points and resets other data in both firestore and realtime
  //syncs realtime db and firestore
  Future<bool> syncDatabase() async {
    _traceSync.start();

    try {
      for (int i = 0; i < ListFunctions.songList.length; i++) {
        database
            .reference()
            .child('songs')
            .child(ListFunctions.songList[i]!.code!)
            .set(ListFunctions.songList[i]!.toMap());
      }

      Timestamp lastUpdated = Timestamp.now();
      CollectionReference others =
          FirebaseFirestore.instance.collection('others');
      others.doc('JAINSONGS').update({
        'lastDatabaseSynced': lastUpdated,
      });

      _traceSync.stop();
      return true;
    } catch (e) {
      _traceSync.stop();
      print('Error syncing realtime database.');
      return false;
    }
  }

  Future<bool> fetchSongs() async {
    _traceRealtime.start();
    ListFunctions.songList.clear();
    DataSnapshot? songSnapshot;

    try {
      bool? isFirstOpen = await SharedPrefs.getIsFirstOpen();

      if (DatabaseController.fromCache == false || isFirstOpen == null) {
        if (isFirstOpen == null) {
          SharedPrefs.setIsFirstOpen(false);
        }

        songSnapshot = await database.reference().child('songs').get();
      } else {
        print('From cache');
        songSnapshot = await database.reference().child('songs').once();
      }

      _readFetchedSongs(songSnapshot, ListFunctions.songList);
      if (ListFunctions.songList.length == 0) {
        return false;
      }
    } catch (e) {
      _traceRealtime.stop();
      print('Error in realtime: $e');
      return false;
    }
    _traceRealtime.stop();
    return true;
  }

  void _readFetchedSongs(
      DataSnapshot songSnapshot, List<SongDetails?> listToAdd) {
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
    //Algorithm is not used here, it is used in firestore side because firestore
    //is updated first.

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
      database.reference().child('songs').child(currentSong.code!).update({
        'trendPoints': currentSong.trendPoints,
      });
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
      return false;
    }
  }

  Future<void> userSelectedFilters(UserFilters userFilters) async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();
    if (isInternetConnected == false) {
      return;
    }

    //XXX: Comment while debugging.
    database
        .reference()
        .child("userBehaviour")
        .child("filters")
        .push()
        .set(userFilters.toMap());
  }
}
