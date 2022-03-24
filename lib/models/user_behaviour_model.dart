import 'package:cloud_firestore/cloud_firestore.dart';

class UserBehaviourModel {
  String code = '';
  String songCode = '';
  String songName = '';
  //This id can be user'sid, onesigal id or fcm id.
  String userId = '';
  //String searched by user in search bar
  String? userSearched;
  //Suggestion opened like: autoplayed suggestion or manual suggestion + suggestion list
  String? suggestionOpened;
  //If song is accessed from a playlist
  String? playlistOpened;
  //Is the song liked by user.
  bool isLiked = false;
  //Songs listened before this song with same configuration.
  int clickedAtRank = -1;
  //Position of song in list like: main list, playlist list or suggestion list.
  int positionInList = -1;
  DateTime? timeOfClick;

  UserBehaviourModel({
    required this.songCode,
    required this.songName,
    this.userId = '',
    this.userSearched,
    this.suggestionOpened,
    this.playlistOpened,
    this.isLiked = false,
    required this.clickedAtRank,
    required this.positionInList,
    this.timeOfClick,
  }) {
    timeOfClick ??= DateTime.now();

    code = songCode;
    if (userSearched != null) {
      code += '_' + userSearched!.trim().toLowerCase();
    }
    if (playlistOpened != null) {
      code += '_' + playlistOpened!.trim().toLowerCase();
    }
    code += '_' + timeOfClick!.millisecondsSinceEpoch.toString();
  }

  void setUserId(String? id) {
    if (id != null) {
      userId = id;
    }
  }

  Map<String, dynamic> toMap() {
    userSearched ??= '';
    playlistOpened ??= '';
    suggestionOpened ??= '';
    timeOfClick ??= DateTime.now();

    return {
      'code': code,
      'songCode': songCode,
      'songName': songName,
      'userId': userId,
      'userSearched': userSearched,
      'suggestionOpened': suggestionOpened,
      'playlistOpened': playlistOpened,
      'isLiked': isLiked,
      'clickedAtRank': clickedAtRank,
      'positionInList': positionInList,
      'timeOfClick': timeOfClick,
    };
  }

  //Used to fetch userbehaviour as JSON.
  Map toJson() {
    userSearched ??= '';
    playlistOpened ??= '';
    suggestionOpened ??= '';
    timeOfClick ??= DateTime.now();

    return {
      'code': code,
      'songCode': songCode,
      'songName': songName,
      'userId': userId,
      'userSearched': userSearched,
      'suggestionOpened': suggestionOpened,
      'playlistOpened': playlistOpened,
      'isLiked': isLiked,
      'clickedAtRank': clickedAtRank,
      'positionInList': positionInList,
      'timeOfClick': timeOfClick?.millisecondsSinceEpoch,
    };
  }

  UserBehaviourModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    code = documentSnapshot['code'];
    songCode = documentSnapshot['songCode'];
    songName = documentSnapshot['songName'];
    userId = documentSnapshot['userId'];
    userSearched = documentSnapshot['userSearched'];
    suggestionOpened = documentSnapshot['suggestionOpened'];
    playlistOpened = documentSnapshot['playlistOpened'];
    isLiked = documentSnapshot['isLiked'];
    clickedAtRank = documentSnapshot['clickedAtRank'];
    positionInList = documentSnapshot['positionInList'];
    timeOfClick = documentSnapshot['timeOfClick'] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            documentSnapshot['timeOfClick'].millisecondsSinceEpoch)
        : null;
  }
}
