import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/services/database/firestore_helper.dart';
import 'package:jain_songs/services/database/realtimeDb_helper.dart';
import 'package:provider/provider.dart';

class DataBaseController {
  //These are fetched from remote config of firebase.
  //Variable to decide which database to use from Realtime and firestore.
  static String dbName = "firestore";
  //Variable to decide whether to recieve data from cache or not.
  static bool fromCache = false;

  Future<bool> fetchSongs(BuildContext context) async {
    bool isSuccess;
    if (dbName.toLowerCase() == 'firestore') {
      isSuccess = await FireStoreHelper().fetchSongs();
    } else {
      isSuccess = await RealtimeDbHelper(
        app: Provider.of<FirebaseApp>(context, listen: false),
      ).fetchSongs();
    }
    return isSuccess;
  }
}
