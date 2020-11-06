import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';

class FireStoreHelper {
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestions =
      FirebaseFirestore.instance.collection('suggestions');

  Future<void> addSuggestions(
      BuildContext context, SongSuggestions songSuggestion) async {
    return suggestions.add(songSuggestion.songSuggestionMap);
  }

  Future<void> changeClicks(
    BuildContext context,
    SongDetails currentSong,
  ) async {
    var docSnap = await songs.doc(currentSong.code).get();
    Map<String, dynamic> songMap = docSnap.data();

    bool isInternetConnected = await NetworkHelper().check();

    if (songMap == null || isInternetConnected == false) {
      currentSong.totalClicks++;
      currentSong.popularity = currentSong.totalClicks + currentSong.likes;
      return;
    }

    if (songMap.containsKey('totalClicks') == false ||
        songMap.containsKey('popularity') == false) {
      songMap['totalClicks'] = 0;
      songMap['popularity'] = 0;
    }

    songMap['totalClicks'] = songMap['totalClicks'] + 1;
    songMap['popularity'] = songMap['totalClicks'] + songMap['likes'];

    await songs.doc(currentSong.code).update({
      'popularity': songMap['popularity'],
      'totalClicks': songMap['totalClicks']
    }).then((value) {
      currentSong.popularity = songMap['popularity'];
      currentSong.totalClicks = songMap['totalClicks'];
    }).catchError((error) {
      print('Error Updating popularity!');
    });
  }

  Future<void> changeShare(
    BuildContext context,
    SongDetails currentSong,
  ) async {
    var docSnap = await songs.doc(currentSong.code).get();
    Map<String, dynamic> songMap = docSnap.data();

    bool isInternetConnected = await NetworkHelper().check();

    if (songMap == null || isInternetConnected == false) {
      currentSong.share++;
      return;
    }

    songMap['share']++;

    await songs
        .doc(currentSong.code)
        .update({'share': songMap['share']}).then((value) {
      currentSong.share = songMap['share'];
    }).catchError((error) {
      print('Error Updating share count in firebase');
    });
  }

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
      setisLiked(currentSong.code, currentSong.isLiked);
    }).catchError((error) {
      currentSong.isLiked = !currentSong.isLiked;
      showToast(context, 'Something went wrong! Please try Later.',
          duration: 2);
    });
  }
}
