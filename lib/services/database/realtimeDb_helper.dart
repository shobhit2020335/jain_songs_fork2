import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/flutter_list_configured/filters.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
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

  //Reading single songs
  SongDetails _readSingleSong(DataSnapshot song, List<SongDetails?> listToAdd) {
    Map<String, dynamic> currentSong = Map<String, dynamic>.from(song.value);
    String state = currentSong['aaa'];
    state = state.toLowerCase();
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
    SharedPrefs.setIsLiked(currentSong['code'], false);
    currentSongDetails.isLiked = false;
    String songInfo =
        '${currentSongDetails.tirthankar} | ${currentSongDetails.genre} | ${currentSongDetails.singer}';
    currentSongDetails.songInfo = trimSpecialChars(songInfo);
    if (currentSongDetails.songInfo.length == 0) {
      currentSongDetails.songInfo = currentSongDetails.songNameHindi!;
    }
    listToAdd.add(
      currentSongDetails,
    );

    if (state.contains('invalid') == true) {
      currentSongDetails.aaa = 'invalid';
    }
    return currentSongDetails;
  }

  Future<bool> fetchSongsData() async {
    try {
      var docSnapshot =
          await database.reference().child('songsData').child('likes').get();
      Map<String, dynamic> likesDataMap =
          Map<String, dynamic>.from(docSnapshot.value);

      docSnapshot =
          await database.reference().child('songsData').child('share').get();
      Map<String, dynamic> shareDataMap =
          Map<String, dynamic>.from(docSnapshot.value);

      docSnapshot = await database
          .reference()
          .child('songsData')
          .child('todayClicks')
          .get();
      Map<String, dynamic> todayClicksDataMap =
          Map<String, dynamic>.from(docSnapshot.value);

      docSnapshot = await database
          .reference()
          .child('songsData')
          .child('totalClicks')
          .get();
      Map<String, dynamic> totalClicksDataMap =
          Map<String, dynamic>.from(docSnapshot.value);

      docSnapshot = await database
          .reference()
          .child('songsData')
          .child('popularity')
          .get();
      Map<String, dynamic> popularityDataMap =
          Map<String, dynamic>.from(docSnapshot.value);

      docSnapshot = await database
          .reference()
          .child('songsData')
          .child('trendPoints')
          .get();
      Map<String, dynamic> trendPointsDataMap =
          Map<String, dynamic>.from(docSnapshot.value);

      for (SongDetails? song in ListFunctions.songList) {
        String code = song!.code!;
        if (likesDataMap.containsKey(code)) {
          song.likes = int.parse(likesDataMap[code].toString());
          song.share = int.parse(shareDataMap[code].toString());
          song.todayClicks = int.parse(todayClicksDataMap[code].toString());
          song.totalClicks = int.parse(totalClicksDataMap[code].toString());
          song.popularity = int.parse(popularityDataMap[code].toString());
          song.trendPoints = double.parse(trendPointsDataMap[code].toString());
          likesDataMap.remove(code);
        } else {
          song.aaa = 'invalid';
        }
      }

      bool isSuccess = await addNewSongs(
        likesDataMap,
        shareDataMap,
        todayClicksDataMap,
        totalClicksDataMap,
        popularityDataMap,
        trendPointsDataMap,
      );
      return isSuccess;
    } catch (e) {
      print('Error fetching songs data: $e');
      return false;
    }
  }

  Future<bool> addNewSongs(
    Map<String, dynamic> likesMap,
    Map<String, dynamic> shareMap,
    Map<String, dynamic> todayClicksMap,
    Map<String, dynamic> totalClicksMap,
    Map<String, dynamic> popularityMap,
    Map<String, dynamic> trendPointsMap,
  ) async {
    try {
      List<String> songNotFound = [];
      likesMap.forEach((key, value) {
        songNotFound.add(key);
      });

      print('Songs which are not found: $songNotFound');
      for (String code in songNotFound) {
        var song = await database.reference().child('songs').child(code).get();
        SongDetails currentSong = _readSingleSong(song, ListFunctions.songList);
        currentSong.likes = int.parse(likesMap[code].toString());
        currentSong.share = int.parse(shareMap[code].toString());
        currentSong.todayClicks = int.parse(todayClicksMap[code].toString());
        currentSong.totalClicks = int.parse(totalClicksMap[code].toString());
        currentSong.popularity = int.parse(popularityMap[code].toString());
        currentSong.trendPoints = double.parse(trendPointsMap[code].toString());
        SQfliteHelper().insertSong(currentSong);
      }
      return true;
    } catch (e) {
      print('Error fetching new songs: $e');
      return false;
    }
  }

  Future<bool> changeClicks(SongDetails currentSong) async {
    //Algorithm is not used here, it is used in firestore side because firestore
    //is updated first.

    try {
      await Future.wait([
        database.reference().child('songsData').child('popularity').update({
          currentSong.code!: ServerValue.increment(1),
        }),
        database.reference().child('songsData').child('todayClicks').update({
          currentSong.code!: ServerValue.increment(1),
        }),
        database.reference().child('songsData').child('totalClicks').update({
          currentSong.code!: ServerValue.increment(1),
        }),
        database.reference().child('songsData').child('trendPoints').update({
          currentSong.code!: currentSong.trendPoints,
        }),
      ]);
      return true;
    } catch (e) {
      print('Error updating clicks or popularity in realtime: $e');
      return false;
    }
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
