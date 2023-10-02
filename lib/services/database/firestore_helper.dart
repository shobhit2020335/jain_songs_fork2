import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/models/post_model.dart';
import 'package:jain_songs/models/user_behaviour_model.dart';
import 'package:jain_songs/services/database/cloud_storage.dart';
import 'package:jain_songs/services/database/sqflite_helper.dart';
import 'package:jain_songs/services/notification/firebase_fcm_manager.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/services/database/realtime_db_helper.dart';
import 'package:jain_songs/services/shared_prefs.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/song_suggestions.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FireStoreHelper {
  final _firestore = FirebaseFirestore.instance;
  final CollectionReference songs =
      FirebaseFirestore.instance.collection('songs');
  final CollectionReference suggestions =
      FirebaseFirestore.instance.collection('suggestions');

  //Error storing user search behaviour
  Future<bool> storeUserSearchBehaviour(
      UserBehaviourModel userBehaviour) async {
    debugPrint('Storing user behaviour');
    try {
      String? fcmToken = await FirebaseFCMManager.getFCMToken();
      userBehaviour.setFCMToken(fcmToken);
      String? playerId = await SharedPrefs.getOneSignalPlayerId();
      userBehaviour.setOneSignalId(playerId);

      //XXX: Remove while debugging
      await _firestore
          .collection('userSearchBehaviour')
          .doc(userBehaviour.code)
          .set(userBehaviour.toMap());

      return true;
    } catch (e) {
      debugPrint('Error storing user search behaviour to firestore: $e');
      return false;
    }
  }

  Future<void> fetchRemoteConfigs() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        minimumFetchInterval: const Duration(seconds: 1),
        fetchTimeout: const Duration(seconds: 4)));
    await remoteConfig.fetchAndActivate();
    Globals.welcomeMessage = remoteConfig.getString('welcome_message');
    DatabaseController.fromCache = remoteConfig.getBool('from_cache');
    DatabaseController.dbName = remoteConfig.getString('db_name');
    DatabaseController.dbForSongsData =
        remoteConfig.getString('db_for_songs_data');
  }

  //Fetches Days of app passed, min version required by user and remote configs.
  Future<void> fetchDaysAndVersion() async {
    bool isInternetConnected = await NetworkHelper().checkNetworkConnection();

    if (isInternetConnected == false) {
      Globals.fetchedDays = Globals.totalDays;
      Globals.fetchedVersion = Globals.appVersion;
      return;
    }
    try {
      await fetchRemoteConfigs();
    } catch (e) {
      debugPrint('error fetching remote config: $e');
      Globals.welcomeMessage = 'Jai Jinendra';
      DatabaseController.dbName = 'firestore';
      DatabaseController.fromCache = false;
      DatabaseController.dbForSongsData = 'firestore';
    }

    try {
      CollectionReference others = _firestore.collection('others');
      var docSnap = await others.doc('JAINSONGS').get();
      Map<String, dynamic> othersMap = docSnap.data() as Map<String, dynamic>;
      Globals.fetchedDays = othersMap['totalDays'];
      Globals.fetchedVersion = othersMap['appVersion'];
      Timestamp timestamp = othersMap['lastSongModifiedTime'];
      Globals.lastSongModifiedTime = timestamp.millisecondsSinceEpoch;
    } catch (e) {
      debugPrint('Error fetching days and version: $e');
      Globals.fetchedDays = Globals.totalDays;
      Globals.fetchedVersion = Globals.appVersion;
    }

    debugPrint('Minimum app version required: ${Globals.fetchedVersion}');
  }

  //It updates the trending points when a new day appears and make todayClicks to 0.
  //It also updates the post releated daily updates
  Future<void> dailyUpdate(
      BuildContext context,
      Map<String, int> todayClicksMap,
      Map<String, double> trendPointsMap) async {
    await Future.wait([
      _firestore
          .collection('songsData')
          .doc('todayClicks')
          .update(todayClicksMap),
      _firestore
          .collection('songsData')
          .doc('trendPoints')
          .update(trendPointsMap),
    ]);

    Timestamp lastUpdated = Timestamp.now();
    CollectionReference others = _firestore.collection('others');
    others.doc('JAINSONGS').update({
      'totalDays': Globals.totalDays,
      'lastUpdated': lastUpdated,
    }).catchError((error) {
      debugPrint('Error updating days $error');
    });

    FirestoreHelperForPost().dailyUpdatePosts();

    await RealtimeDbHelper(
      Globals.firebaseApp,
    ).syncDatabase();
  }

  Future<bool> fetchSongs() async {
    debugPrint('Fetching songs from Firestore');
    bool isSuccess = false;
    ListFunctions.songList.clear();
    QuerySnapshot songs;

    try {
      bool? isFirstOpen = await SharedPrefs.getIsFirstOpen();

      if (DatabaseController.fromCache == false || isFirstOpen == null) {
        if (isFirstOpen == null) {
          SharedPrefs.setIsFirstOpen(false);
        }
        songs = await _firestore.collection('songs').get();
      } else {
        songs = await _firestore
            .collection('songs')
            .get(const GetOptions(source: Source.cache));
        if (songs.size == 0) {
          songs = await _firestore.collection('songs').get();
        }
      }
      if (songs.size == 0) {
        return false;
      }

      isSuccess = await _readFetchedSongs(songs, ListFunctions.songList);
    } catch (e) {
      debugPrint('Error fetching songs from firestore: $e');
      return false;
    }
    return isSuccess;
  }

  Future<bool> _readFetchedSongs(
      QuerySnapshot songs, List<SongDetails?> listToAdd) async {
    try {
      for (var song in songs.docs) {
        Map<String, dynamic> currentSong = song.data() as Map<String, dynamic>;
        String state = currentSong['aaa'];
        state = state.toLowerCase();
        if (state.contains('invalid') != true) {
          Timestamp timestamp = currentSong['lastModifiedTime'];
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
            youTubeLink: currentSong['youTubeLink'],
            lastModifiedTime: timestamp.millisecondsSinceEpoch,
          );
          bool? valueIsliked =
              await SharedPrefs.getIsLiked(currentSong['code']);
          if (valueIsliked == null) {
            SharedPrefs.setIsLiked(currentSong['code'], false);
            valueIsliked = false;
          }
          currentSongDetails.isLiked = valueIsliked;
          String songInfo =
              '${currentSongDetails.tirthankar} | ${currentSongDetails.genre} | ${currentSongDetails.singer}';
          currentSongDetails.songInfo = trimSpecialChars(songInfo);
          if (currentSongDetails.songInfo.isEmpty) {
            currentSongDetails.songInfo = currentSongDetails.songNameHindi!;
          }
          listToAdd.add(
            currentSongDetails,
          );
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error in reading from firestore: $e');
      return false;
    }
  }

  SongDetails _readSingleSong(
      DocumentSnapshot song, List<SongDetails?> listToAdd) {
    Map<String, dynamic> currentSong = song.data() as Map<String, dynamic>;
    String state = currentSong['aaa'];
    state = state.toLowerCase();
    Timestamp timestamp = currentSong['lastModifiedTime'];
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
      youTubeLink: currentSong['youTubeLink'],
      lastModifiedTime: timestamp.millisecondsSinceEpoch,
    );
    SharedPrefs.setIsLiked(currentSong['code'], false);
    currentSongDetails.isLiked = false;
    String songInfo =
        '${currentSongDetails.tirthankar} | ${currentSongDetails.genre} | ${currentSongDetails.singer}';
    currentSongDetails.songInfo = trimSpecialChars(songInfo);
    if (currentSongDetails.songInfo.isEmpty) {
      currentSongDetails.songInfo = currentSongDetails.songNameHindi!;
    }
    listToAdd.add(
      currentSongDetails,
    );

    if (state.contains('invalid') == true) {
      currentSongDetails.aaa = 'invalid';
    }
    return currentSongDetails;
  }

  Future<bool> fetchSongsData(BuildContext context) async {
    try {
      var docSnapshot =
          await _firestore.collection('songsData').doc('likes').get();
      Map<String, dynamic> likesDataMap =
          Map<String, dynamic>.from(docSnapshot.data()!);

      docSnapshot = await _firestore.collection('songsData').doc('share').get();
      Map<String, dynamic> shareDataMap =
          Map<String, dynamic>.from(docSnapshot.data()!);

      docSnapshot =
          await _firestore.collection('songsData').doc('todayClicks').get();
      Map<String, dynamic> todayClicksDataMap =
          Map<String, dynamic>.from(docSnapshot.data()!);

      docSnapshot =
          await _firestore.collection('songsData').doc('totalClicks').get();
      Map<String, dynamic> totalClicksDataMap =
          Map<String, dynamic>.from(docSnapshot.data()!);

      docSnapshot =
          await _firestore.collection('songsData').doc('popularity').get();
      Map<String, dynamic> popularityDataMap =
          Map<String, dynamic>.from(docSnapshot.data()!);

      docSnapshot =
          await _firestore.collection('songsData').doc('trendPoints').get();
      Map<String, dynamic> trendPointsDataMap =
          Map<String, dynamic>.from(docSnapshot.data()!);

      for (SongDetails? song in ListFunctions.songList) {
        String code = song!.code!;
        if (likesDataMap.containsKey(code)) {
          song.likes = int.parse(likesDataMap[code].toString());
          song.share = int.parse(shareDataMap[code].toString());
          song.todayClicks = int.parse(todayClicksDataMap[code].toString());
          song.totalClicks = int.parse(totalClicksDataMap[code].toString());
          song.popularity = int.parse(popularityDataMap[code].toString());
          song.trendPoints = double.parse(trendPointsDataMap[code].toString());
          likesDataMap.remove(code);
        } else {
          song.aaa = 'invalid';
        }
      }

      bool isSuccess = await addNewSongs(
        likesDataMap,
        shareDataMap,
        todayClicksDataMap,
        totalClicksDataMap,
        popularityDataMap,
        trendPointsDataMap,
      );

      if (isSuccess) {
        DatabaseController()
            .dailyUpdate(context, todayClicksDataMap, totalClicksDataMap);
      }
      return isSuccess;
    } catch (e) {
      debugPrint('Error fetching songs data: $e');
      return false;
    }
  }

  Future<bool> addNewSongs(
    Map<String, dynamic> likesMap,
    Map<String, dynamic> shareMap,
    Map<String, dynamic> todayClicksMap,
    Map<String, dynamic> totalClicksMap,
    Map<String, dynamic> popularityMap,
    Map<String, dynamic> trendPointsMap,
  ) async {
    try {
      List<String> songNotFound = [];
      likesMap.forEach((key, value) {
        songNotFound.add(key);
      });

      debugPrint('Songs which are not found: $songNotFound');
      for (String code in songNotFound) {
        var song = await songs.doc(code).get();
        SongDetails currentSong = _readSingleSong(song, ListFunctions.songList);
        currentSong.likes = int.parse(likesMap[code].toString());
        currentSong.share = int.parse(shareMap[code].toString());
        currentSong.todayClicks = int.parse(todayClicksMap[code].toString());
        currentSong.totalClicks = int.parse(totalClicksMap[code].toString());
        currentSong.popularity = int.parse(popularityMap[code].toString());
        currentSong.trendPoints = double.parse(trendPointsMap[code].toString());
        SQfliteHelper().insertSong(currentSong);
      }
      return true;
    } catch (e) {
      debugPrint('Error fetching new songs: $e');
      return false;
    }
  }

  //Get data of latest modification made in a song and then updates it into SQL.
  Future<bool> syncNewSongs(int lastSyncTime) async {
    try {
      bool isSuccess = true;
      QuerySnapshot songs = await _firestore
          .collection('songs')
          .where('lastModifiedTime',
              isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(lastSyncTime))
          .get(GetOptions(
              source: DatabaseController.fromCache
                  ? Source.cache
                  : Source.serverAndCache));

      for (var song in songs.docs) {
        isSuccess = isSuccess &
            await SQfliteHelper()
                .updateSong(song.data() as Map<String, dynamic>);
      }
      return isSuccess;
    } catch (e) {
      debugPrint('Error syncing new songs: $e');
      return false;
    }
  }

  Future<void> addSuggestions(
      SongSuggestions songSuggestion, List<File> images) async {
    String suggestionUID = removeWhiteSpaces(songSuggestion.songName).trim() +
        randomAlphaNumeric(8).trim();

    for (int i = 0; i < images.length; i++) {
      String imageURL = await CloudStorage()
          .uploadSuggestionImage(images[0], '${i + 1}$suggestionUID');
      songSuggestion.addImagesLink(imageURL);
    }

    String? fcmToken = await FirebaseFCMManager.getFCMToken();
    songSuggestion.setFCMToken(fcmToken);

    String? playerId = await SharedPrefs.getOneSignalPlayerId();
    songSuggestion.setOneSignalPlayerId(playerId);

    return suggestions.doc(suggestionUID).set(songSuggestion.songSuggestionMap);
  }

  Future<bool> changeClicks(SongDetails currentSong) async {
    int todayClicks = currentSong.todayClicks! + 1;
    int totalClicks = currentSong.totalClicks! + 1;

    //Algo for trendPoints
    double avgClicks = totalClicks / Globals.totalDays;
    double nowTrendPoints = todayClicks - avgClicks;
    double trendPointInc = nowTrendPoints - currentSong.trendPoints!;

    if (nowTrendPoints < currentSong.trendPoints!) {
      trendPointInc = 0;
    }

    try {
      await Future.wait([
        _firestore.collection('songsData').doc('popularity').update({
          currentSong.code!: FieldValue.increment(1),
        }),
        _firestore.collection('songsData').doc('totalClicks').update({
          currentSong.code!: FieldValue.increment(1),
        }),
        _firestore.collection('songsData').doc('todayClicks').update({
          currentSong.code!: FieldValue.increment(1),
        }),
        _firestore.collection('songsData').doc('trendPoints').update({
          currentSong.code!: FieldValue.increment(trendPointInc),
        }),
      ]);
      debugPrint('All Futures runned');
      currentSong.todayClicks = currentSong.todayClicks! + 1;
      currentSong.totalClicks = currentSong.totalClicks! + 1;
      currentSong.popularity = currentSong.popularity! + 1;
      currentSong.trendPoints = currentSong.trendPoints! + trendPointInc;

      return true;
    } catch (e) {
      debugPrint('Error changing clicks on firestore: $e');
      return false;
    }
  }

  Future<bool> changeShare(SongDetails currentSong) async {
    try {
      await _firestore
          .collection('songsData')
          .doc('share')
          .update({currentSong.code!: FieldValue.increment(1)});
      currentSong.share = currentSong.share! + 1;
      return true;
    } catch (e) {
      debugPrint('Error increasing shares of song: $e');
      return false;
    }
  }

  Future<bool> changeLikes(
      BuildContext context, SongDetails currentSong, int toAdd) async {
    try {
      await Future.wait([
        _firestore.collection('songsData').doc('likes').update({
          currentSong.code!: FieldValue.increment(toAdd),
        }),
        _firestore.collection('songsData').doc('popularity').update({
          currentSong.code!: FieldValue.increment(toAdd),
        }),
      ]);
      SharedPrefs.setIsLiked(currentSong.code!, currentSong.isLiked);
      return true;
    } catch (e) {
      debugPrint('Error updating likes in firestore: $e');
      return false;
    }
  }
}

class FirestoreHelperForPost extends FireStoreHelper {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<bool> changeViewsOfPosts(PostModel postModel) async {
    try {
      int todayViews = postModel.todayViews + 1;
      int totalViews = postModel.totalViews + 1;

      //Algo for trendPoints
      double trendPoint = todayViews / totalViews;
      int trendPoints = (trendPoint * 100).toInt();

      await postsCollection.doc(postModel.code).update({
        'todayViews': FieldValue.increment(1),
        'totalViews': FieldValue.increment(1),
        'popularity': FieldValue.increment(1),
        'trendPoints': trendPoints,
      });

      postModel.todayViews = todayViews;
      postModel.totalViews = totalViews;
      postModel.trendPoints = trendPoints;
      postModel.popularity += 1;

      return true;
    } catch (e) {
      debugPrint('Error changing posts views in firestore: $e');
      return false;
    }
  }

  Future<bool> changeDownloadsOfPosts(PostModel postModel) async {
    try {
      await postsCollection.doc(postModel.code).update({
        'downloadedBy': FieldValue.increment(1),
        'popularity': FieldValue.increment(3),
      });

      postModel.downloadedBy += 1;
      postModel.popularity += 3;
      return true;
    } catch (e) {
      debugPrint('Error changing downloads in firestore: $e');
      return false;
    }
  }

  Future<bool> changeStatusAppliedCountOfPosts(PostModel postModel) async {
    try {
      await postsCollection.doc(postModel.code).update({
        'appliedOnStatusBy': FieldValue.increment(1),
        'popularity': FieldValue.increment(2),
      });

      postModel.appliedOnStatusBy += 1;
      postModel.popularity += 2;
      return true;
    } catch (e) {
      debugPrint('Error changing applied on status count in firestore: $e');
      return false;
    }
  }

  //TODO: Check this, enabled but read and views are not stored when clicked
  Future<void> dailyUpdatePosts() async {
    try {
      var collection = await postsCollection.get();

      for (var post in collection.docs) {
        int newTrendPoints = (post['trendPoints'] / 2).toInt();

        postsCollection.doc(post.id).update({
          'todayViews': 0,
          'trendPoints': newTrendPoints,
        });
      }
    } catch (e) {
      debugPrint('Error in daily update for posts');
    }
  }

  //TODO: Also find solution for playlist specific post fetching
  //Also try to reduce reads combining both the ways
  Future<bool> fetchPostsOfSong(String songCode) async {
    debugPrint('Fetching posts of song: $songCode from firestore');
    ListFunctions.postsToShow.clear();
    QuerySnapshot posts;

    try {
      bool? isFirstOpen = await SharedPrefs.getIsFirstOpen();

      if (!ListFunctions.postsFetchedForSongs.contains(songCode)) {
        if (DatabaseController.fromCache == false || isFirstOpen == null) {
          if (isFirstOpen == null) {
            SharedPrefs.setIsFirstOpen(false);
          }
          posts = await _firestore
              .collection('posts')
              .where('linkedSongs', arrayContains: songCode)
              .get();
        } else {
          posts = await _firestore
              .collection('posts')
              .where('linkedSongs', arrayContains: songCode)
              .get(const GetOptions(source: Source.cache));

          if (posts.size == 0) {
            posts = await _firestore
                .collection('posts')
                .where('linkedSongs', arrayContains: songCode)
                .get();
          }
        }

        for (var post in posts.docs) {
          PostModel postModel = PostModel.fromDocumentSnapshot(post);
          if (postModel.isAvailableForStatus) {
            ListFunctions.postsToShow.add(postModel);
          }
          if (!ListFunctions.postsFetched.contains(postModel.code)) {
            ListFunctions.allPosts.add(postModel);
          }
          ListFunctions.postsFetched.add(postModel.code);
        }
        ListFunctions.postsFetchedForSongs.add(songCode);
      } else {
        for (int i = 0; i < ListFunctions.allPosts.length; i++) {
          if (ListFunctions.allPosts[i].linkedSongs!.contains(songCode) &&
              ListFunctions.allPosts[i].isAvailableForStatus) {
            ListFunctions.postsToShow.add(ListFunctions.allPosts[i]);
          }
        }
      }

      ListFunctions.postsToShow.sort(_trendComparison);

      return true;
    } catch (e) {
      debugPrint('Error fetching posts of a song: $e');
      return false;
    }
  }

  //Fethces a other posts if a song does not have its specific post
  //TODO: Now its fetching most popular posts. But it should be changed
  //to fetch posts related to song code. Also the status must not be
  //seen by the user in this session
  Future<bool> fetchRelatedPosts(String keywords) async {
    debugPrint('Fetching related post for song from firestore');
    ListFunctions.postsToShow.clear();
    QuerySnapshot posts;

    try {
      bool? isFirstOpen = await SharedPrefs.getIsFirstOpen();

      if (DatabaseController.fromCache == false || isFirstOpen == null) {
        if (isFirstOpen == null) {
          SharedPrefs.setIsFirstOpen(false);
        }
        posts = await _firestore
            .collection('posts')
            .orderBy('popularity', descending: true)
            .limit(3)
            .get();
      } else {
        posts = await _firestore
            .collection('posts')
            .orderBy('popularity', descending: true)
            .limit(3)
            .get(const GetOptions(source: Source.cache));
        if (posts.size == 0) {
          posts = await _firestore
              .collection('posts')
              .orderBy('popularity', descending: true)
              .limit(3)
              .get();
        }
      }

      for (var post in posts.docs) {
        PostModel postModel = PostModel.fromDocumentSnapshot(post);
        if (postModel.isAvailableForStatus) {
          ListFunctions.postsToShow.add(postModel);
        }
        if (!ListFunctions.postsFetched.contains(postModel.code)) {
          ListFunctions.allPosts.add(postModel);
        }
        ListFunctions.postsFetched.add(postModel.code);
      }

      if (ListFunctions.postsToShow.isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error fetching releated posts: $e');
      return false;
    }
  }

  int _trendComparison(PostModel? a, PostModel? b) {
    final propertyA = a!.trendPoints;
    final propertyB = b!.trendPoints;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }
}
