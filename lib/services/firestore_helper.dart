import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/song_details.dart';

class FireStoreHelper {
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<void> changeShare(
    BuildContext context,
    SongDetails currentSong,
  ) async {}

  Future<void> changeLikes(
      BuildContext context, SongDetails currentSong, bool toAdd) async {
    var docSnap = await songs.doc(currentSong.code).get();
    Map<String, dynamic> songMap = docSnap.data();

    bool isInternetConnected = await NetworkHelper().check();

    if (songMap == null || isInternetConnected == false) {
      showToast(context, 'No Internet connection!', duration: 2);
      currentSong.isLiked = !currentSong.isLiked;
      return;
    }

    songMap['likes'] = toAdd ? songMap['likes'] + 1 : songMap['likes'] - 1;

    await songs
        .doc(currentSong.code)
        .update({'likes': songMap['likes']}).then((value) {
      currentSong.likes = songMap['likes'];
    }).catchError((error) {
      currentSong.isLiked = !currentSong.isLiked;
      showToast(context, 'Something went wrong! Please try Later.',
          duration: 2);
    });
  }
}
