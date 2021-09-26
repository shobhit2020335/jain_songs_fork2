import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/database/realtimeDb_helper.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:provider/provider.dart';

class DatabaseController {
  //These are fetched from remote config of firebase.
  //Variable to decide which database to use from Realtime and firestore for fetching songs.
  static String dbName = 'firestore';
  //Variable to decide which database to use for fetching songsData
  static String dbForSongsData = 'firestore';
  //Variable to decide whether to recieve data from cache or not.
  static bool fromCache = false;

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
      ).fetchSongsData();
      if (isSuccess == false) {
        isSuccess = await FireStoreHelper().fetchSongsData();
      }
    } else {
      isSuccess = await FireStoreHelper().fetchSongsData();
      if (isSuccess == false) {
        isSuccess = await RealtimeDbHelper(
          Provider.of<FirebaseApp>(context, listen: false),
        ).fetchSongsData();
      }
    }
    return isSuccess;
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
  Future<bool> changeShare(
      BuildContext context, SongDetails currentSong) async {
    bool isSuccess = await FireStoreHelper().changeShare(currentSong);
    isSuccess = isSuccess &
        await RealtimeDbHelper(
          Provider.of<FirebaseApp>(context, listen: false),
        ).changeShare(currentSong);
    return isSuccess;
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
    if (isSuccess == false) {
      ConstWidget.showSimpleToast(
        context,
        'Something went wrong! Please try Later.',
      );
    }
    return isSuccess;
  }
}
