import 'package:flutter/cupertino.dart';

class SongDetails {
  String album;
  String category;
  String code;
  String genre;
  bool isLiked;
  String language;
  int likes;
  String lyrics;
  String englishLyrics;
  String originalSong;
  int popularity;
  String production;
  String searchKeywords;
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
        @required this.category,
      this.code,
      this.genre,
      this.language,
      this.likes: 0,
      this.lyrics,
      this.englishLyrics,
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
    if (this.trendPoints == null) {
      this.trendPoints = 0.0;
    }
    if (this.todayClicks == null) {
      this.todayClicks = 0;
    }
    if (totalClicks == null) {
      this.totalClicks = 0;
    }
    if (popularity == null) {
      this.popularity = 0;
    }
    if (likes == null) {
      this.likes = 0;
    }
    if (this.englishLyrics == null || this.englishLyrics.length <= 2) {
      this.englishLyrics =
          "English lyrics not Available right now! Switch language to Hindi.\n";
    }
    if(this.category == null || this.category.length < 2){
      this.category = 'stavan';
    }
  }
}
