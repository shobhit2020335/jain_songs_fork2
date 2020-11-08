import 'package:flutter/cupertino.dart';

class SongDetails {
  String album;
  String code;
  String genre;
  bool isLiked;
  int likes;
  String lyrics;
  String originalSong;
  int popularity;
  String production;
  List searchKeywords;
  int share;
  String singer;
  String songNameEnglish;
  String songNameHindi;
  String tirthankar;
  int todayClicks;
  int totalClicks;
  double trendPoints;
  String youTubeLink;

  SongDetails(
      {this.album,
      this.code,
      this.genre: 'Bhakti',
      this.likes: 0,
      this.lyrics,
      this.originalSong: 'Unknown',
      this.popularity: 0,
      this.production,
      @required this.searchKeywords,
      this.share,
      this.singer,
      this.songNameEnglish,
      this.songNameHindi,
      this.tirthankar,
      this.todayClicks: 0,
      this.totalClicks: 0,
      this.trendPoints: 0,
      this.youTubeLink}) {
    //TODO: Include in state management.
    if (this.trendPoints == null) {
      this.trendPoints = 0;
    }
    if (this.todayClicks == null) {
      this.todayClicks = 0;
    }
  }
}
