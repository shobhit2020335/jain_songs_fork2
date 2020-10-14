//TODO: Create backup in local devices

import 'package:flutter/cupertino.dart';

class SongDetails {
  String album;
  String code;
  String genre;
  bool isLiked;
  int likes;
  String lyrics;
  String originalSong;
  String production;
  int share;
  String singer;
  String songNameEnglish;
  String songNameHindi;
  String tirthankar;
  String youTubeLink;

  SongDetails(
      {this.album,
      this.code,
      this.genre: 'Bhakti',
      this.likes: 0,
      this.lyrics,
      this.originalSong: 'Unknown',
      this.production,
      this.share,
      this.singer,
      this.songNameEnglish,
      this.songNameHindi,
      this.tirthankar,
      this.youTubeLink}) {
    //TODO: Include in state management.
    this.isLiked = false;
  }
}
