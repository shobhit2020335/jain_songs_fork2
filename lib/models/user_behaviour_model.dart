class UserBehaviourModel {
  String code = '';
  String songCode;
  String songName;
  //This id can be user'sid, onesigal id or fcm id.
  String oneSignalId = '';
  String fcmToken = '';
  //String searched by user in search bar
  String? userSearched;
  //Suggestion opened like: autoplayed suggestion or manual suggestion + suggestion list
  String? suggestionOpened;
  //If song is accessed from a playlist
  String? playlistOpened;
  //Is the song liked by user.
  bool isLiked = false;
  //Songs listened before this song with same configuration.
  int clickedAtRank;
  //Position of song in list like: main list, playlist list or suggestion list.
  int positionInList;
  DateTime? timeOfClick;

  UserBehaviourModel({
    required this.songCode,
    required this.songName,
    this.oneSignalId = '',
    this.fcmToken = '',
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

  void setOneSignalId(String? id) {
    if (id != null) {
      oneSignalId = id;
    }
  }

  void setFCMToken(String? token) {
    if (token != null) {
      fcmToken = token;
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
      'oneSignalId': oneSignalId,
      'fcmToken': fcmToken,
      'userSearched': userSearched,
      'suggestionOpened': suggestionOpened,
      'playlistOpened': playlistOpened,
      'isLiked': isLiked,
      'clickedAtRank': clickedAtRank,
      'positionInList': positionInList,
      'timeOfClick': timeOfClick,
    };
  }
}
