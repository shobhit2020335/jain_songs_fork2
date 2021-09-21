class SongDetails {
  //ADD the new variable in table creation too.
  String aaa;
  String? album;
  String? category;
  String? code;
  String? englishLyrics;
  String? genre;
  String? gujaratiLyrics;
  String? language;
  int? likes;
  String? lyrics;
  String? originalSong;
  int? popularity;
  String? production;
  String? searchKeywords;
  int? share;
  String? singer;
  String? songNameEnglish;
  String? songNameHindi;
  String? tirthankar;
  int? todayClicks;
  int? totalClicks;
  double? trendPoints;
  String? youTubeLink;
  //Used locally not stored in DBs.
  bool isLiked;
  int level1;
  int level2;
  int level3;
  int level4;
  String songInfo;

  //Used to create SQflite table
  static String createSongTable =
      'CREATE TABLE songs(code TEXT PRIMARY KEY, aaa TEXT, album TEXT, category TEXT, '
      'englishLyrics TEXT, genre TEXT, gujaratiLyrics TEXT,isLiked INTEGER, likes INTEGER, language TEXT, '
      'lyrics TEXT, originalSong TEXT, popularity INTEGER, production TEXT, searchKeywords TEXT, '
      'share INTEGER, singer TEXT, songNameEnglish TEXT, songNameHindi TEXT, tirthankar TEXT, '
      'todayClicks INTEGER, totalClicks INTEGER, trendPoints REAL, youTubeLink TEXT)';

  static String deleteSongTable = 'DROP TABLE IF EXISTS songs';

  SongDetails({
    this.aaa: 'valid',
    this.album,
    this.category: "",
    this.code,
    this.genre: '',
    this.gujaratiLyrics,
    this.language: '',
    this.isLiked: false,
    this.likes: 0,
    this.lyrics,
    this.englishLyrics,
    this.originalSong: 'Unknown',
    this.popularity: 0,
    this.production,
    this.searchKeywords: '',
    this.share: 0,
    this.singer,
    this.songNameEnglish,
    this.songNameHindi,
    this.tirthankar: '',
    this.todayClicks: 0,
    this.totalClicks: 0,
    this.trendPoints: 0,
    this.youTubeLink,
    this.level1: 0,
    this.level2: 0,
    this.level3: 0,
    this.level4: 0,
    this.songInfo: '',
  }) {
    if (searchKeywords == null) {
      this.searchKeywords = 'song';
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
    if (this.englishLyrics == null || this.englishLyrics!.length <= 1) {
      this.englishLyrics = "NA";
    }
    if (this.gujaratiLyrics == null || this.gujaratiLyrics!.length <= 1) {
      this.gujaratiLyrics = "NA";
    }
  }

  Map<String, dynamic> toMapForSQflite() {
    return {
      'aaa': 'valid',
      'album': album,
      'category': category,
      'code': code,
      'englishLyrics': englishLyrics,
      'genre': genre,
      'gujaratiLyrics': gujaratiLyrics,
      'language': language,
      'likes': likes,
      'isLiked': isLiked ? 1 : 0,
      'lyrics': lyrics,
      'originalSong': originalSong,
      'popularity': popularity,
      'production': production,
      'searchKeywords': searchKeywords,
      'share': share,
      'singer': singer,
      'songNameEnglish': songNameEnglish,
      'songNameHindi': songNameHindi,
      'tirthankar': tirthankar,
      'todayClicks': todayClicks,
      'totalClicks': totalClicks,
      'trendPoints': trendPoints,
      'youTubeLink': youTubeLink,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'aaa': 'valid',
      'album': album,
      'category': category,
      'code': code,
      'englishLyrics': englishLyrics,
      'genre': genre,
      'gujaratiLyrics': gujaratiLyrics,
      'language': language,
      'likes': likes,
      'lyrics': lyrics,
      'originalSong': originalSong,
      'popularity': popularity,
      'production': production,
      'searchKeywords': searchKeywords,
      'share': share,
      'singer': singer,
      'songNameEnglish': songNameEnglish,
      'songNameHindi': songNameHindi,
      'tirthankar': tirthankar,
      'todayClicks': todayClicks,
      'totalClicks': totalClicks,
      'trendPoints': trendPoints,
      'youTubeLink': youTubeLink,
    };
  }
}
