import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/database/realtimeDb_helper.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:provider/provider.dart';
import '../network_helper.dart';
import '../sharedPrefs.dart';

class DatabaseController {
  //These are fetched from remote config of firebase.
  //Variable to decide which database to use from realtime and firestore for fetching songs
  static String dbName = 'realtime';
  //Variable to decide which database to use for fetching songsData
  static String dbForSongsData = 'firestore';
  //Variable to decide whether to recieve data from cache or not.
  static bool fromCache = false;

  //The function SQL fetch complete is called only if data is fetched from SQl.
  Future<bool> fetchSongs(BuildContext context,
      {required Function() onSqlFetchComplete}) async {
    bool isSuccess = false;
    isSuccess = await SQfliteHelper().fetchSongs();
    if (isSuccess) {
      onSqlFetchComplete();
    } else {
      //TODO: Add log here that sql se not fetching
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
        Globals.firebaseApp,
      ).fetchSongsData(context);
      if (isSuccess == false) {
        isSuccess = await FireStoreHelper().fetchSongsData(context);
      }
    } else {
      isSuccess = await FireStoreHelper().fetchSongsData(context);
      if (isSuccess == false) {
        isSuccess = await RealtimeDbHelper(
          Globals.firebaseApp,
        ).fetchSongsData(context);
      }
    }

    //Syncs the changes from firebase
    if (isSuccess) {
      syncNewChanges(context).then((value) {
        if (value) {
          SharedPrefs.setLastSyncTime(Globals.lastSongModifiedTime);
        } else {
          print('Already synced or Error in syncing new changes: $value');
        }
      });
    }
    return isSuccess;
  }

  //This function works only with firestore because there is no way to query
  //data from realtime DB as per my knowledge.
  Future<bool> syncNewChanges(BuildContext context) async {
    try {
      int? lastSyncTime = await SharedPrefs.getLastSyncTime();
      lastSyncTime ??= DateTime(2020, 12, 25, 12).millisecondsSinceEpoch;
      bool isSuccess = false;
      if (Globals.lastSongModifiedTime > lastSyncTime) {
        isSuccess = await FireStoreHelper().syncNewSongs(lastSyncTime);
      }
      return isSuccess;
    } catch (e) {
      print('Error Syncing new changes: $e');
      return false;
    }
  }

  Future<void> dailyUpdate(
      BuildContext context,
      Map<String, dynamic> todayClicksMap,
      Map<String, dynamic> totalClicksMap) async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();
    if (Globals.totalDays > Globals.fetchedDays! && isInternetConnected) {
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
      } catch (e) {
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
        Globals.firebaseApp,
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
        Globals.firebaseApp,
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
          Globals.firebaseApp,
        ).changeLikes(context, currentSong, toAdd);
    isSuccess = isSuccess & await SQfliteHelper().changeLikes(currentSong);
    return isSuccess;
  }
}

//TODO:
//This is database controller for the posts
class DatabaseControllerForPosts extends DatabaseController {
  //Fetches the post required for a particular song
  Future<bool> fetchPostsOfSong(String songCode, String searchKeywords) async {
    try {
      bool isSuccess =
          await FirestoreHelperForPost().fetchPostsOfSong(songCode);
      if (isSuccess == false || ListFunctions.postsToShow.isEmpty) {
        isSuccess =
            await FirestoreHelperForPost().fetchRelatedPosts(searchKeywords);
      }

      return isSuccess;
    } catch (e) {
      print('Error fetching posts from firestore: $e');
      return false;
    }
  }
}
