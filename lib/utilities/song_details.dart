//TODO: Create backup in local devices

import 'package:flutter/cupertino.dart';

class SongDetails {
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
      {@required this.lyrics,
      this.movie,
      this.originalSong,
      this.production,
      this.singer,
      @required this.songNameEnglish,
      @required this.songNameHindi,
      this.tirthankar,
      this.youTubeLink}) {
    this.isLiked = false;
    this.likes = 0;
    this.share = 0;
  }
}
