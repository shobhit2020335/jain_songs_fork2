import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static Future<String> fetchRemoteConfigs() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        minimumFetchInterval: Duration(seconds: 1),
        fetchTimeout: Duration(seconds: 4)));
    await remoteConfig.fetchAndActivate();
    String message = remoteConfig.getString('welcome_message');
    fromCache = remoteConfig.getBool('from_cache');
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

    await fetchRemoteConfigs().then((value) {
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

    bool isFirstOpen = await SharedPrefs.getIsFirstOpen();

    if (fromCache == false || isFirstOpen == null) {
      if (isFirstOpen == null) {
        SharedPrefs.setIsFirstOpen(false);
      }
      songs = await _firestore.collection('songs').get();
    } else {
      songs = await _firestore
          .collection('songs')
          .get(GetOptions(source: Source.cache));
      if (songs == null || songs.size == 0) {
        songs = await _firestore.collection('songs').get();
      }
    }

    await _readFetchedSongs(songs, songList);
    _trace2.stop();
  }

  //TODO: Reduce reads here
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
        bool valueIsliked = await SharedPrefs.getIsLiked(currentSong['code']);
        if (valueIsliked == null) {
          SharedPrefs.setIsLiked(currentSong['code'], false);
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
    String suggestionUID = removeWhiteSpaces(songSuggestion.songName).trim() +
        randomAlphaNumeric(6).trim();

    String fcmToken = await FirebaseFCMManager.getFCMToken();
    songSuggestion.setFCMToken(fcmToken);

    String playerId = await SharedPrefs.getOneSignalPlayerId();
    songSuggestion.setOneSignalPlayerId(playerId);

    return suggestions.doc(suggestionUID).set(songSuggestion.songSuggestionMap);
  }

  Future<void> changeClicks(SongDetails currentSong) async {
    int todayClicks = currentSong.todayClicks + 1;
    int totalClicks = currentSong.totalClicks + 1;

    //Algo for trendPoints
    double avgClicks = totalClicks / totalDays;
    double nowTrendPoints = todayClicks - avgClicks;
    double trendPointInc = nowTrendPoints - currentSong.trendPoints;

    if (nowTrendPoints < currentSong.trendPoints) {
      trendPointInc = 0;
    }

    await songs.doc(currentSong.code).update({
      'popularity': FieldValue.increment(1),
      'totalClicks': FieldValue.increment(1),
      'todayClicks': FieldValue.increment(1),
      'trendPoints': FieldValue.increment(trendPointInc),
    }).then((value) {
      currentSong.todayClicks++;
      currentSong.totalClicks++;
      currentSong.popularity++;
      currentSong.trendPoints = currentSong.trendPoints + trendPointInc;
    }).catchError((error) {
      print('Error Updating popularity or trendPoints!');
    });
  }

  Future<void> changeShare(SongDetails currentSong) async {
    await songs
        .doc(currentSong.code)
        .update({'share': FieldValue.increment(1)}).then((value) {
      currentSong.share++;
    }).catchError((error) {
      print('Error Updating share count in firebase');
    });
  }

  Future<void> changeLikes(
      BuildContext context, SongDetails currentSong, int toAdd) async {
    await songs.doc(currentSong.code).update({
      'likes': FieldValue.increment(toAdd),
      'popularity': FieldValue.increment(toAdd)
    }).then((value) {
      currentSong.likes = currentSong.likes + toAdd;
      currentSong.popularity = currentSong.popularity + toAdd;
      SharedPrefs.setIsLiked(currentSong.code, currentSong.isLiked);
    }).catchError((error) {
      currentSong.isLiked = !currentSong.isLiked;
      showSimpleToast(
        context,
        'Something went wrong! Please try Later.',
      );
    });
  }
}
