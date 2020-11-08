import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';

class FireStoreHelper {
  final _firestore = FirebaseFirestore.instance;
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

    if (songMap.containsKey('popularity') == false) {
      songMap['popularity'] = 0;
    }

    songMap['likes'] = toAdd ? songMap['likes'] + 1 : songMap['likes'] - 1;
    songMap['popularity'] =
        toAdd ? songMap['popularity'] + 1 : songMap['popularity'] - 1;

    await songs.doc(currentSong.code).update({
      'likes': songMap['likes'],
      'popularity': songMap['popularity']
    }).then((value) {
      currentSong.likes = songMap['likes'];
      currentSong.popularity = songMap['popularity'];
      setisLiked(currentSong.code, currentSong.isLiked);
    }).catchError((error) {
      currentSong.isLiked = !currentSong.isLiked;
      showToast(context, 'Something went wrong! Please try Later.',
          duration: 2);
    });
  }

  Future<void> getSongs(String query) async {
    songList.clear();

    QuerySnapshot songs;
    if (query == '') {
      songs = await _firestore.collection('songs').get();
    } else {
      songs = await _firestore
          .collection('songs')
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .get();
    }
    for (var song in songs.docs) {
      Map<String, dynamic> currentSong = song.data();
      String state = currentSong['aaa'];
      if (state != 'Invalid' && state != 'invalid') {
        SongDetails currentSongDetails = SongDetails(
            album: currentSong['album'],
            code: currentSong['code'],
            genre: currentSong['genre'],
            lyrics: currentSong['lyrics'],
            songNameEnglish: currentSong['songNameEnglish'],
            songNameHindi: currentSong['songNameHindi'],
            originalSong: currentSong['originalSong'],
            popularity: currentSong['popularity'],
            production: currentSong['production'],
            searchKeywords: currentSong['searchKeywords'],
            singer: currentSong['singer'],
            tirthankar: currentSong['tirthankar'],
            totalClicks: currentSong['totalClicks'],
            likes: currentSong['likes'],
            share: currentSong['share'],
            youTubeLink: currentSong['youTubeLink']);
        bool valueIsliked = await getisLiked(currentSong['code']);
        if (valueIsliked == null) {
          setisLiked(currentSong['code'], false);
          valueIsliked = false;
        }
        currentSongDetails.isLiked = valueIsliked;
        songList.add(
          currentSongDetails,
        );
      }
    }
  }
}
