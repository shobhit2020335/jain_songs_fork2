class UserSearchBehaviourModel {
  String code = '';
  String songCode;
  String songName;
  //String searched by user in search bar
  String? userSearched;
  //Filters applied by the user.
  List<String>? filters;
  //If song is accessed from a playlist
  String? playlistOpened;
  //Is the song liked by user.
  bool isLiked = false;
  //Songs listened before this song with same configuration.
  int clickedAtRank;
  //Position of song in list visible
  int positionInList;
  DateTime? timeOfClick;

  UserSearchBehaviourModel({
    required this.songCode,
    required this.songName,
    this.userSearched,
    this.filters,
    this.playlistOpened,
    this.isLiked = false,
    required this.clickedAtRank,
    required this.positionInList,
    this.timeOfClick,
  }) {
    code = songCode;
    if (userSearched != null) {
      code += '_' + userSearched!.trim().toLowerCase();
    }
    if (playlistOpened != null) {
      code += '_' + playlistOpened!.trim().toLowerCase();
    }
    if (filters != null && filters!.isNotEmpty) {
      code += '_' + filters!.first;
    }

    if (filters == null) {
      filters = [];
    }

    if (timeOfClick == null) {
      timeOfClick = DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    userSearched ??= '';
    filters ??= [];
    playlistOpened ??= '';
    timeOfClick ??= DateTime.now();

    return {
      'code': code,
      'songCode': songCode,
      'songName': songName,
      'userSearched': userSearched,
      'filters': filters,
      'playlistOpened': playlistOpened,
      'isLiked': isLiked,
      'clickedAtRank': clickedAtRank,
      'positionInList': positionInList,
      'timeOfClick': timeOfClick,
    };
  }
}
