//TODO: Create backup in local devices

import 'package:flutter/cupertino.dart';

class SongDetails {
  String code;
  bool isLiked;
  int likes;
  String lyrics;
  String movie;
  String originalSong;
  String production;
  int share;
  String singer;
  String songNameEnglish;
  String songNameHindi;
  String tirthankar;
  String youTubeLink;

  SongDetails(
      {@required this.code,
      this.likes: 0,
      @required this.lyrics,
      this.movie,
      this.originalSong: 'Unknown',
      this.production,
      this.share,
      this.singer,
      @required this.songNameEnglish,
      @required this.songNameHindi,
      this.tirthankar,
      this.youTubeLink}) {
    //TODO: Include in state management.
    this.isLiked = false;
  }
}
