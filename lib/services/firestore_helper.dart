import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/flutter_list_configured/filters.dart';
import 'package:jain_songs/services/FirebaseFCMManager.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FireStoreHelper {
  final _firestore = FirebaseFirestore.instance;
  final Trace _trace = FirebasePerformance.instance.newTrace('dailyUpdate');
  final Trace _trace2 = FirebasePerformance.instance.newTrace('getSongs');
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestions =
      FirebaseFirestore.instance.collection('suggestions');

  static Future<String> fetchWelcomeMessage() async {
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: Duration(hours: 1));
    await remoteConfig.activateFetched();
    String message = remoteConfig.getString('welcome_message');
    return message;
  }

  //Storing the user's selected filters in realtime database.
  Future<void> userSelectedFilters(UserFilters userFilters) async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();
    if (isInternetConnected == false) {
      return;
    }

    //TODO: Comment while debugging.
    // final DatabaseReference databaseReference =
    //     FirebaseDatabase.instance.reference();
    // databaseReference
    //     .child("userBehaviour")
    //     .child("filters")
    //     .push()
    //     .set(userFilters.toMap());
  }

  Future<void> fetchDaysAndVersion() async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();

    if (isInternetConnected == false) {
      fetchedDays = totalDays;
      fetchedVersion = appVersion;
      return;
    }
    CollectionReference others = _firestore.collection('others');
    var docSnap = await others.doc('JAINSONGS').get();
    Map<String, dynamic> othersMap = docSnap.data();

    FireStoreHelper.fetchWelcomeMessage().then((value) {
      welcomeMessage = value;
    }).onError((error, stackTrace) {
      welcomeMessage = 'Jai Jinendra';
    });

    fetchedDays = othersMap['totalDays'];
    fetchedVersion = othersMap['appVersion'];
    print(fetchedVersion);
  }

  //It updates the trending points when a new day appears and make todayClicks to 0.
  Future<void> dailyUpdate() async {
    _trace.start();
    songList.clear();

    QuerySnapshot songs;
    songs = await _firestore.collection('songs').get();

    for (var song in songs.docs) {
      Map<String, dynamic> songMap = song.data();
      String state = songMap['aaa'];
      state = state.toLowerCase();
      if (state.contains('invalid') != true) {
        int todayClicks = songMap['todayClicks'];
        int totalClicks = songMap['totalClicks'];

        //Algo for trendPoints
        double avgClicks = totalClicks / totalDays;
        songMap['trendPoints'] = (todayClicks - avgClicks) / 2;
        songMap['todayClicks'] = 0;

        await this.songs.doc(songMap['code']).update({
          'todayClicks': songMap['todayClicks'],
          'trendPoints': songMap['trendPoints'],
        }).catchError((error) {
          print('Error Updating popularity!');
        });
      }
    }

    Timestamp lastUpdated = Timestamp.now();
    CollectionReference others = _firestore.collection('others');
    others.doc('JAINSONGS').update({
      'totalDays': totalDays,
      'lastUpdated': lastUpdated,
    }).catchError((error) {
      print('Error updating days.' + error);
    });
    _trace.stop();

    await _readFetchedSongs(songs, songList);
  }

  Future<void> getSongs() async {
    _trace2.start();
    songList.clear();

    QuerySnapshot songs;
    songs = await _firestore.collection('songs').get();

    await _readFetchedSongs(songs, songList);
    _trace2.stop();
  }

  Future<void> getPopularSongs() async {
    listToShow.clear();
    QuerySnapshot songs;
    songs = await _firestore
        .collection('songs')
        .orderBy('popularity', descending: true)
        .limit(30)
        .get();

    await _readFetchedSongs(songs, listToShow);
  }

  Future<void> _readFetchedSongs(
      QuerySnapshot songs, List<SongDetails> listToAdd) async {
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
        listToAdd.add(
          currentSongDetails,
        );
      }
    }
  }

  Future<void> addSuggestions(
      BuildContext context, SongSuggestions songSuggestion) async {
    String suggestionUID =
        removeWhiteSpaces(songSuggestion.songName) + randomAlphaNumeric(6);
    String fcmToken = await FirebaseFCMManager.getFCMToken();
    songSuggestion.setFCMToken(fcmToken);
    return suggestions.doc(suggestionUID).set(songSuggestion.songSuggestionMap);
  }

  Future<void> changeClicks(
      BuildContext context, SongDetails currentSong) async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();

    if (isInternetConnected == false) {
      currentSong.totalClicks++;
      currentSong.todayClicks++;
      currentSong.popularity = currentSong.totalClicks + currentSong.likes;
      return;
    }

    var docSnap = await songs.doc(currentSong.code).get();
    Map<String, dynamic> songMap = docSnap.data();

    if (songMap == null) {
      currentSong.totalClicks++;
      currentSong.todayClicks++;
      currentSong.popularity = currentSong.totalClicks + currentSong.likes;
      return;
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

  Future<void> changeShare(SongDetails currentSong) async {
    currentSong.share++;
    await songs
        .doc(currentSong.code)
        .update({'share': FieldValue.increment(1)}).catchError((error) {
      print('Error Updating share count in firebase');
    });
  }

  Future<void> changeLikes(SongDetails currentSong, int toAdd) async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();

    if (isInternetConnected == false) {
      showToast('No Internet connection!', toastColor: Colors.red);
      currentSong.isLiked = !currentSong.isLiked;
      return;
    }

    await songs.doc(currentSong.code).update({
      'likes': FieldValue.increment(toAdd),
      'popularity': FieldValue.increment(toAdd)
    }).then((value) {
      currentSong.likes = currentSong.likes + toAdd;
      currentSong.popularity = currentSong.popularity + toAdd;
      setisLiked(currentSong.code, currentSong.isLiked);
    }).catchError((error) {
      currentSong.isLiked = !currentSong.isLiked;
      showToast('Something went wrong! Please try Later.',
          toastLength: Toast.LENGTH_SHORT, toastColor: Colors.red);
    });
  }
}
