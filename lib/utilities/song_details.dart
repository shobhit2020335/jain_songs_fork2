class SongDetails {
  String album;
  String category;
  String code;
  String englishLyrics;
  String genre;
  String gujaratiLyrics;
  bool isLiked;
  String language;
  int likes;
  String lyrics;
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
      this.category: "Stavan",
      this.code,
      this.genre,
      this.gujaratiLyrics,
      this.language,
      this.likes: 0,
      this.lyrics,
      this.englishLyrics,
      this.originalSong: 'Unknown',
      this.popularity: 0,
      this.production,
      this.searchKeywords,
      this.share,
      this.singer,
      this.songNameEnglish,
      this.songNameHindi,
      this.tirthankar,
      this.todayClicks: 0,
      this.totalClicks: 0,
      this.trendPoints: 0,
      this.youTubeLink}) {
    if (searchKeywords == null) {
      this.searchKeywords = '';
    }
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
    if (this.englishLyrics == null || this.englishLyrics.length <= 1) {
      this.englishLyrics = "NA";
    }
    if (this.gujaratiLyrics == null || this.gujaratiLyrics.length <= 1) {
      this.gujaratiLyrics = "NA";
    }
  }
}
