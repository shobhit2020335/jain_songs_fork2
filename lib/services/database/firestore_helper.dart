import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/database/cloud_storage.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
import 'package:jain_songs/services/notification/FirebaseFCMManager.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/database/realtimeDb_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:jain_songs/utilities/songsData_details.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FireStoreHelper {
  final _firestore = FirebaseFirestore.instance;
  final Trace _trace = FirebasePerformance.instance.newTrace('dailyUpdate');
  final Trace _trace2 = FirebasePerformance.instance.newTrace('getSongs');
  final CollectionReference songs =
      FirebaseFirestore.instance.collection('songs');
  final CollectionReference suggestions =
      FirebaseFirestore.instance.collection('suggestions');

  Future<void> fetchRemoteConfigs() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        minimumFetchInterval: Duration(seconds: 1),
        fetchTimeout: Duration(seconds: 4)));
    await remoteConfig.fetchAndActivate();
    Globals.welcomeMessage = remoteConfig.getString('welcome_message');
    DatabaseController.fromCache = remoteConfig.getBool('from_cache');
    DatabaseController.dbName = remoteConfig.getString('db_name');
  }

  //Fetches Days of app passed, min version required by user and remote configs.
  Future<void> fetchDaysAndVersion() async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();

    if (isInternetConnected == false) {
      Globals.fetchedDays = Globals.totalDays;
      Globals.fetchedVersion = Globals.appVersion;
      return;
    }
    try {
      await fetchRemoteConfigs();
    } catch (e) {
      print('error fetching remote config: $e');
      Globals.welcomeMessage = 'Jai Jinendra';
      DatabaseController.dbName = 'firestore';
      DatabaseController.fromCache = false;
    }

    try {
      CollectionReference others = _firestore.collection('others');
      var docSnap = await others.doc('JAINSONGS').get();
      Map<String, dynamic> othersMap = docSnap.data() as Map<String, dynamic>;
      Globals.fetchedDays = othersMap['totalDays'];
      Globals.fetchedVersion = othersMap['appVersion'];
    } catch (e) {
      print(e);
      Globals.fetchedDays = Globals.totalDays;
      Globals.fetchedVersion = Globals.appVersion;
    }

    print(Globals.fetchedVersion);
  }

  //It updates the trending points when a new day appears and make todayClicks to 0.
  Future<void> dailyUpdate(BuildContext context) async {
    _trace.start();

    for (SongDetails? currentSong in ListFunctions.songList) {
      int? todayClicks = currentSong?.todayClicks;
      int? totalClicks = currentSong?.totalClicks;

      //Algo for trendPoints
      double avgClicks = totalClicks! / Globals.totalDays;
      double trendPoints = (todayClicks! - avgClicks) / 2.0;
      currentSong!.todayClicks = 0;
      currentSong.trendPoints = trendPoints;

      await this.songs.doc(currentSong.code).update({
        'todayClicks': currentSong.todayClicks,
        'trendPoints': currentSong.trendPoints,
      }).catchError((error) {
        print('Error in daily update firestore!');
      });
    }

    Timestamp lastUpdated = Timestamp.now();
    CollectionReference others = _firestore.collection('others');
    others.doc('JAINSONGS').update({
      'totalDays': Globals.totalDays,
      'lastUpdated': lastUpdated,
    }).catchError((error) {
      print('Error updating days.' + error);
    });
    _trace.stop();

    await RealtimeDbHelper(
      Provider.of<FirebaseApp>(context, listen: false),
    ).syncDatabase();
  }

  Future<bool> fetchSongs() async {
    _trace2.start();
    ListFunctions.songList.clear();
    QuerySnapshot songs;

    try {
      bool? isFirstOpen = await SharedPrefs.getIsFirstOpen();

      if (DatabaseController.fromCache == false || isFirstOpen == null) {
        if (isFirstOpen == null) {
          SharedPrefs.setIsFirstOpen(false);
        }
        songs = await _firestore.collection('songs').get();
      } else {
        songs = await _firestore
            .collection('songs')
            .get(GetOptions(source: Source.cache));
        if (songs.size == 0) {
          songs = await _firestore.collection('songs').get();
        }
      }
      if (songs.size == 0) {
        _trace2.stop();
        return false;
      }

      await _readFetchedSongs(songs, ListFunctions.songList);
    } catch (e) {
      _trace2.stop();
      print(e);
      return false;
    }
    _trace2.stop();
    return true;
  }

  Future<void> _readFetchedSongs(
      QuerySnapshot songs, List<SongDetails?> listToAdd) async {
    for (var song in songs.docs) {
      Map<String, dynamic> currentSong = song.data() as Map<String, dynamic>;
      String state = currentSong['aaa'];
      state = state.toLowerCase();
      if (state.contains('invalid') != true) {
        SongDetails currentSongDetails = SongDetails(
            album: currentSong['album'],
            code: currentSong['code'],
            category: currentSong['category'],
            genre: currentSong['genre'],
            gujaratiLyrics: currentSong['gujaratiLyrics'],
            language: currentSong['language'],
            lyrics: currentSong['lyrics'],
            englishLyrics: currentSong['englishLyrics'],
            songNameEnglish: currentSong['songNameEnglish'],
            songNameHindi: currentSong['songNameHindi'],
            originalSong: currentSong['originalSong'],
            popularity: currentSong['popularity'],
            production: currentSong['production'],
            searchKeywords: currentSong['searchKeywords'],
            singer: currentSong['singer'],
            tirthankar: currentSong['tirthankar'],
            todayClicks: currentSong['todayClicks'],
            totalClicks: currentSong['totalClicks'],
            trendPoints: currentSong['trendPoints'],
            likes: currentSong['likes'],
            share: currentSong['share'],
            youTubeLink: currentSong['youTubeLink']);
        bool? valueIsliked = await SharedPrefs.getIsLiked(currentSong['code']);
        if (valueIsliked == null) {
          SharedPrefs.setIsLiked(currentSong['code'], false);
          valueIsliked = false;
        }
        currentSongDetails.isLiked = valueIsliked;
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
    }
  }

  Future<bool> fetchSongsData() async {
    try {
      var docSnapshot =
          await _firestore.collection('songsData').doc('points').get();
      Map<String, dynamic>? songDataMap =
          docSnapshot.data() as Map<String, dynamic>;

      List<SongsDataDetails> songDataList = [];
      List<String> code = List<String>.from(songDataMap['code']);
      List<int> likes = List<int>.from(songDataMap['likes']);
      List<int> popularity = List<int>.from(songDataMap['popularity']);
      List<int> share = List<int>.from(songDataMap['share']);
      List<int> todayClicks = List<int>.from(songDataMap['todayClicks']);
      List<int> totalClicks = List<int>.from(songDataMap['totalClicks']);
      List<double> trendPoints = List<double>.from(songDataMap['trendPoints']);

      for (int i = 0; i < code.length; i++) {
        SongsDataDetails songsDataDetails = SongsDataDetails(
          code: code[i],
          likes: likes[i],
          popularity: popularity[i],
          share: share[i],
          todayClicks: todayClicks[i],
          totalClicks: totalClicks[i],
          trendPoints: trendPoints[i],
        );
        songDataList.add(songsDataDetails);
      }

      songDataList.sort(_codeComparison);

      List<String> songNotFound = [];
      int i = 0, j = 0;

      while (i < songDataList.length && j < ListFunctions.songList.length) {
        String codeFromData = songDataList[i].code!;
        String codeFromSong = ListFunctions.songList[j]!.code!;
        if (codeFromSong == codeFromData) {
          ListFunctions.songList[j]?.popularity = songDataList[i].popularity;
          ListFunctions.songList[j]?.todayClicks = songDataList[i].todayClicks;
          ListFunctions.songList[j]?.totalClicks = songDataList[i].totalClicks;
          ListFunctions.songList[j]?.trendPoints = songDataList[i].trendPoints;
          i++;
          j++;
        } else if (codeFromData.compareTo(codeFromSong) < 0) {
          songNotFound.add(codeFromData);
          i++;
        } else if (codeFromData.compareTo(codeFromSong) > 0) {
          ListFunctions.songList[j]?.aaa = 'invalid';
          j++;
        }
      }

      while (i < songDataList.length) {
        songNotFound.add(songDataList[i].code!);
        i++;
      }
      while (j < ListFunctions.songList.length) {
        ListFunctions.songList[j]?.aaa = 'invalid';
        j++;
      }
      return true;
    } catch (e) {
      print('Error fetching songs data: $e');
      return false;
    }
  }

  int _codeComparison(SongsDataDetails a, SongsDataDetails b) {
    final String propertyA = a.code!;
    final String propertyB = b.code!;

    if (propertyA.compareTo(propertyB) < 0) {
      return -1;
    } else if (propertyA.compareTo(propertyB) > 0) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<void> addSuggestions(
      SongSuggestions songSuggestion, List<File> images) async {
    String suggestionUID = removeWhiteSpaces(songSuggestion.songName).trim() +
        randomAlphaNumeric(8).trim();

    for (int i = 0; i < images.length; i++) {
      String imageURL = await CloudStorage()
          .uploadSuggestionImage(images[0], '${i + 1}' + suggestionUID);
      songSuggestion.addImagesLink(imageURL);
    }

    String? fcmToken = await FirebaseFCMManager.getFCMToken();
    songSuggestion.setFCMToken(fcmToken);

    String? playerId = await SharedPrefs.getOneSignalPlayerId();
    songSuggestion.setOneSignalPlayerId(playerId);

    return suggestions.doc(suggestionUID).set(songSuggestion.songSuggestionMap);
  }

  //TODO: SUggestion data storing is paused for paryushan timing.
  Future<void> storeSuggesterStreak(
      String songCode, String suggestionStreak) async {
    // String suggestionUID = removeWhiteSpaces('Suggester_${songCode}_').trim() +
    //     randomAlphaNumeric(6).trim();

    // SongSuggestions songSuggestion = SongSuggestions(

    //     'v1.3.1',
    //     '${suggestionStreak[0]}',
    //     '-1=DynamicLink, 0=NoPlaylist, 1=Playlist, lyrics=songVis',
    //     '${ListFunctions.songsVisited.toList()}',
    //     '$suggestionStreak');

    // String? fcmToken = await FirebaseFCMManager.getFCMToken();
    // songSuggestion.setFCMToken(fcmToken);

    // String? playerId = await SharedPrefs.getOneSignalPlayerId();
    // songSuggestion.setOneSignalPlayerId(playerId);

    // //XXX: Comment while debugging.
    // return suggestions.doc(suggestionUID).set(songSuggestion.songSuggestionMap);
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

    try {
      await songs.doc(currentSong.code).update({
        'popularity': FieldValue.increment(1),
        'totalClicks': FieldValue.increment(1),
        'todayClicks': FieldValue.increment(1),
        'trendPoints': FieldValue.increment(trendPointInc),
      }).then((value) {
        currentSong.todayClicks = currentSong.todayClicks! + 1;
        currentSong.totalClicks = currentSong.totalClicks! + 1;
        currentSong.popularity = currentSong.popularity! + 1;
        currentSong.trendPoints = currentSong.trendPoints! + trendPointInc;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeShare(SongDetails currentSong) async {
    try {
      await songs
          .doc(currentSong.code)
          .update({'share': FieldValue.increment(1)}).then((value) {
        currentSong.share = currentSong.share! + 1;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeLikes(
      BuildContext context, SongDetails currentSong, int toAdd) async {
    try {
      await songs.doc(currentSong.code).update({
        'likes': FieldValue.increment(toAdd),
        'popularity': FieldValue.increment(toAdd)
      }).then((value) {
        currentSong.likes = currentSong.likes! + toAdd;
        currentSong.popularity = currentSong.popularity! + toAdd;
        SharedPrefs.setIsLiked(currentSong.code!, currentSong.isLiked);
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
