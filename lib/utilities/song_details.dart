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
  //Last modified song time has different storing format in different places.
  //In firestore it is stored as TimeStamp, in realtime DB,
  //SQflite as int and in sharedPrefs (last Sync time) as int. So, it must
  //be typeCast properly everywhere.
  int? lastModifiedTime;

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
      'todayClicks INTEGER, totalClicks INTEGER, trendPoints REAL, youTubeLink TEXT, lastModifiedTime INTEGER)';

  //Used to delete songs table
  static String deleteSongTable = 'DROP TABLE IF EXISTS songs';

  SongDetails({
    this.aaa = 'valid',
    this.album,
    this.category = "",
    this.code,
    this.genre = '',
    this.gujaratiLyrics,
    this.language = '',
    this.isLiked = false,
    this.likes = 0,
    this.lyrics,
    this.englishLyrics,
    this.originalSong = 'Unknown',
    this.popularity = 0,
    this.production,
    this.searchKeywords = '',
    this.share = 0,
    this.singer,
    this.songNameEnglish,
    this.songNameHindi,
    this.tirthankar = '',
    this.todayClicks = 0,
    this.totalClicks = 0,
    this.trendPoints = 0,
    this.youTubeLink,
    this.level1 = 0,
    this.level2 = 0,
    this.level3 = 0,
    this.level4 = 0,
    this.songInfo = '',
    this.lastModifiedTime,
  }) {
    lastModifiedTime ??= DateTime(2020, 12, 25, 12).millisecondsSinceEpoch;
    searchKeywords ??= 'song';
    trendPoints ??= 0.0;
    todayClicks ??= 0;
    totalClicks ??= 0;
    popularity ??= 0;
    likes ??= 0;
    if (englishLyrics == null || englishLyrics!.length <= 1) {
      englishLyrics = "NA";
    }
    if (gujaratiLyrics == null || gujaratiLyrics!.length <= 1) {
      gujaratiLyrics = "NA";
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
      'lastModifiedTime': lastModifiedTime,
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
      'lastModifiedTime': lastModifiedTime,
    };
  }
}
