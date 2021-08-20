import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/services/firestore_helper.dart';
import 'package:jain_songs/services/realtimeDb_helper.dart';
import 'package:provider/provider.dart';

class DatabaseController {
  //These are fetched from remote config of firebase.
  //Variable to decide which database to use from Realtime and firestore.
  static String dbName = "firestore";
  //Variable to decide whether to recieve data from cache or not.
  static bool fromCache = false;

  Future<bool> fetchSongs(BuildContext context) async {
    bool isSuccess = false;
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
    return isSuccess;
  }
}
