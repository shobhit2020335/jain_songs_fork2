import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:firebase_performance/firebase_performance.dart';

class FireStoreHelper {
  final _firestore = FirebaseFirestore.instance;
  final Trace _trace = FirebasePerformance.instance.newTrace('dailyUpdate');
  final Trace _trace2 = FirebasePerformance.instance.newTrace('getSongs');
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestions =
      FirebaseFirestore.instance.collection('suggestions');

  Future<void> fetchDaysAndVersion() async {
    bool isInternetConnected = await NetworkHelper().check();

    if (isInternetConnected == false) {
      fetchedDays = totalDays;
      fetchedVersion = appVersion;
      return;
    }
    CollectionReference others = _firestore.collection('others');
    var docSnap = await others.doc('JAINSONGS').get();
    Map<String, dynamic> othersMap = docSnap.data();

    fetchedDays = othersMap['totalDays'];
    fetchedVersion = othersMap['appVersion'];
    print(fetchedVersion);
  }

  //It updates the trending points when a new day appears and make todayClicks to 0.
  Future<void> dailyUpdate() async {
    _trace.start();
    bool isInternetConnected = await NetworkHelper().check();

    if (isInternetConnected == false) {
      return;
    }

    QuerySnapshot songs;
    songs = await _firestore.collection('songs').get();

    for (var song in songs.docs) {
      Map<String, dynamic> songMap = song.data();
      String state = songMap['aaa'];
      state = state.toLowerCase();
      if (state.contains('invalid') != true) {
        if (songMap.containsKey('totalClicks') == false) {
          songMap['totalClicks'] = 0;
        }
        if (songMap.containsKey('todayClicks') == false ||
            songMap.containsKey('trendPoints') == false) {
          songMap['todayClicks'] = 0;
          songMap['trendPoints'] = 0;
        }

        int todayClicks = songMap['todayClicks'];
        int totalClicks = songMap['totalClicks'];

        //Algo for trendPoints
        double avgClicks = totalClicks / totalDays;
        songMap['trendPoints'] = todayClicks - avgClicks;
        songMap['todayClicks'] = 0;

        await this.songs.doc(songMap['code']).update({
          'todayClicks': songMap['todayClicks'],
          'trendPoints': songMap['trendPoints'],
        }).catchError((error) {
          print('Error Updating popularity!');
        });
      }
    }

    CollectionReference others = _firestore.collection('others');
    await others.doc('JAINSONGS').update({
      'totalDays': totalDays,
    }).catchError((error) {
      print('Error updating days.' + error);
    });
    _trace.stop();
  }

  Future<void> getSongs() async {
    _trace2.start();
    songList.clear();

    QuerySnapshot songs;
    songs = await _firestore.collection('songs').get();

    for (var song in songs.docs) {
      Map<String, dynamic> currentSong = song.data();
      String state = currentSong['aaa'];
      state = state.toLowerCase();
      if (state.contains('invalid') != true) {
        SongDetails currentSongDetails = SongDetails(
            album: currentSong['album'],
            code: currentSong['code'],
            category: currentSong['category'],
            genre: currentSong['genre'],
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
        bool valueIsliked = await getisLiked(currentSong['code']);
        if (valueIsliked == null) {
          setisLiked(currentSong['code'], false);
          valueIsliked = false;
        }
        currentSongDetails.isLiked = valueIsliked;
        String originalSong = currentSongDetails.originalSong;
        if (originalSong == null ||
            originalSong.length < 3 ||
            originalSong.toLowerCase() == 'unknown') {
          currentSongDetails.originalSong = currentSongDetails.songNameHindi;
        }
        songList.add(
          currentSongDetails,
        );
      }
    }
    _trace2.stop();
  }

  Future<void> addSuggestions(
      BuildContext context, SongSuggestions songSuggestion) async {
    return suggestions.add(songSuggestion.songSuggestionMap);
  }

  Future<void> changeClicks(
      BuildContext context, SongDetails currentSong) async {
    var docSnap = await songs.doc(currentSong.code).get();
    Map<String, dynamic> songMap = docSnap.data();

    bool isInternetConnected = await NetworkHelper().check();

    if (songMap == null || isInternetConnected == false) {
      currentSong.totalClicks++;
      currentSong.todayClicks++;
      currentSong.popularity = currentSong.totalClicks + currentSong.likes;
      return;
    }

    if (songMap.containsKey('totalClicks') == false ||
        songMap.containsKey('popularity') == false) {
      songMap['totalClicks'] = 0;
      songMap['popularity'] = 0;
    }
    if (songMap.containsKey('todayClicks') == false ||
        songMap.containsKey('trendPoints') == false) {
      songMap['todayClicks'] = 0;
      songMap['trendPoints'] = 0;
    }

    int todayClicks = songMap['todayClicks'] + 1;
    int totalClicks = songMap['totalClicks'] + 1;
    songMap['totalClicks'] = totalClicks;
    songMap['popularity'] = totalClicks + songMap['likes'];
    songMap['todayClicks'] = todayClicks;

    //Algo for trendPoints
    double avgClicks = totalClicks / totalDays;
    double nowTrendPoints = todayClicks - avgClicks;
    if (nowTrendPoints > songMap['trendPoints']) {
      songMap['trendPoints'] = todayClicks - avgClicks;
    }

    await songs.doc(currentSong.code).update({
      'popularity': songMap['popularity'],
      'totalClicks': songMap['totalClicks'],
      'todayClicks': songMap['todayClicks'],
      'trendPoints': songMap['trendPoints'],
    }).then((value) {
      currentSong.popularity = songMap['popularity'];
      currentSong.totalClicks = songMap['totalClicks'];
    }).catchError((error) {
      print('Error Updating popularity or trendPoints!');
    });
  }

  Future<void> changeShare(
      BuildContext context, SongDetails currentSong) async {
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
}
