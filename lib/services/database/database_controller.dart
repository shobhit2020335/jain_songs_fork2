import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/database/realtimeDb_helper.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:provider/provider.dart';

import '../network_helper.dart';

class DatabaseController {
  //These are fetched from remote config of firebase.
  //Variable to decide which database to use from Realtime and firestore for fetching songs.
  static String dbName = 'firestore';
  //Variable to decide which database to use for fetching songsData
  static String dbForSongsData = 'firestore';
  //Variable to decide whether to recieve data from cache or not.
  static bool fromCache = false;
  final Trace _trace = FirebasePerformance.instance.newTrace('dailyUpdate');

  //The function SQl fetch complete is called only if data is fetched from SQl.
  Future<bool> fetchSongs(BuildContext context,
      {required onSqlFetchComplete()}) async {
    bool isSuccess = false;
    isSuccess = await SQfliteHelper().fetchSongs();
    if (isSuccess) {
      onSqlFetchComplete();
    } else {
      if (dbName == 'realtime') {
        isSuccess = await RealtimeDbHelper(
          Provider.of<FirebaseApp>(context, listen: false),
        ).fetchSongs();
      }
      if (isSuccess == false) {
        isSuccess = await FireStoreHelper().fetchSongs();
        if (isSuccess == false) {
          isSuccess = await RealtimeDbHelper(
            Provider.of<FirebaseApp>(context, listen: false),
          ).fetchSongs();
        }
      }
    }
    return isSuccess;
  }

  //Fetches the song data from realtime or firestore according to remote config
  //If one way does not works then it tries the another.
  Future<bool> fetchSongsData(BuildContext context) async {
    bool isSuccess = false;
    if (dbForSongsData == 'realtime') {
      print('Realtime se fetching songData');
      isSuccess = await RealtimeDbHelper(
        Provider.of<FirebaseApp>(context, listen: false),
      ).fetchSongsData(context);
      if (isSuccess == false) {
        isSuccess = await FireStoreHelper().fetchSongsData(context);
      }
    } else {
      isSuccess = await FireStoreHelper().fetchSongsData(context);
      if (isSuccess == false) {
        isSuccess = await RealtimeDbHelper(
          Provider.of<FirebaseApp>(context, listen: false),
        ).fetchSongsData(context);
      }
    }
    return isSuccess;
  }

  Future<void> dailyUpdate(
      BuildContext context,
      Map<String, dynamic> todayClicksMap,
      Map<String, dynamic> totalClicksMap) async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();
    if (Globals.totalDays > Globals.fetchedDays! && isInternetConnected) {
      _trace.start();
      try {
        Globals.fetchedDays = Globals.totalDays;
        Map<String, int> newTodayClicksMap = {};
        Map<String, double> newTrendPointsMap = {};

        todayClicksMap.forEach((key, value) {
          int todayClicks = int.parse(todayClicksMap[key].toString());
          int totalClicks = int.parse(totalClicksMap[key].toString());

          //Algo for trendPoints
          double avgClicks = totalClicks / Globals.totalDays;
          double trendPoints = (todayClicks - avgClicks) / 2.0;
          newTodayClicksMap[key] = 0;
          newTrendPointsMap[key] = trendPoints;
        });

        await FireStoreHelper()
            .dailyUpdate(context, newTodayClicksMap, newTrendPointsMap);
        _trace.stop();
      } catch (e) {
        _trace.stop();
        print('Error in daily update: $e');
      }
    }
  }

  //Clicks are changed in both realtime and firestore.
  Future<void> changeClicks(
      BuildContext context, SongDetails currentSong) async {
    bool isSuccess = await FireStoreHelper().changeClicks(currentSong);
    if (isSuccess) {
      RealtimeDbHelper(
        Provider.of<FirebaseApp>(context, listen: false),
      ).changeClicks(currentSong);
      SQfliteHelper().changeClicks(currentSong);
    } else {
      print('Error changing clicks');
    }
  }

  //Shares are changed in both realtime and firestore.
  Future<void> changeShare(
      BuildContext context, SongDetails currentSong) async {
    bool isSuccess = await FireStoreHelper().changeShare(currentSong);
    if (isSuccess) {
      RealtimeDbHelper(
        Provider.of<FirebaseApp>(context, listen: false),
      ).changeShare(currentSong);
      SQfliteHelper().changeShare(currentSong);
    } else {
      print('Error changing share');
    }
  }

  //Likes are changed in both realtime and firestore.
  Future<bool> changeLikes(
      BuildContext context, SongDetails currentSong, int toAdd) async {
    bool isSuccess =
        await FireStoreHelper().changeLikes(context, currentSong, toAdd);
    isSuccess = isSuccess &
        await RealtimeDbHelper(
          Provider.of<FirebaseApp>(context, listen: false),
        ).changeLikes(context, currentSong, toAdd);
    isSuccess = isSuccess & await SQfliteHelper().changeLikes(currentSong);
    return isSuccess;
  }
}
