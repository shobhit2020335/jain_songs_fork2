import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';

class Suggester {
  List<SongDetails> level1Songs = [];
  List<SongDetails> level2Songs = [];
  List<SongDetails> level3Songs = [];
  List<SongDetails> level4Songs = [];
  int streakCount = 0;
  static int maxStreakCount = 0;
  static List<SongDetails> suggestedSongs = [];
  Map<String, String> level1 = {};

  Map<int, Map<String, String>> _previousStreakLevels = {
    0: {},
    1: {},
    2: {},
    3: {},
    4: {},
  };
  Map<int, Map<String, String>> _currentStreakLevels = {
    0: {},
    1: {},
    2: {},
    3: {},
    4: {},
  };

  Suggester({this.streakCount: 0, this.level1}) {
    if (level1 == null) {
      level1 = {};
    } else {
      _currentStreakLevels[1] = level1;
      _previousStreakLevels[1] = level1;
    }
  }

  Future<void> fetchSuggestions(SongDetails currentSong) async {
    //First it increases the streak count.
    streakCount++;
    if (streakCount > maxStreakCount) {
      maxStreakCount = streakCount;
    }
    //Clears all the previous list which got populated.
    suggestedSongs.clear();
    level1Songs.clear();
    level2Songs.clear();
    level3Songs.clear();
    level4Songs.clear();
    //Clears the streak level 0 which contains what to exclude for previous song.
    _currentStreakLevels[0].clear();

    _resetStreakLevels();
    _createStreakLevels(currentSong);
    _dropOrIncreaseStreakValues(currentSong);
    _mergeStreakValues(currentSong);
    _populateLevel1List();
    _suggestFirstSong();
    suggestedSongs.add(level4Songs[0]);
    _suggestSecondSong();
  }

  void _suggestSecondSong() {
    _removeSuggestedSongFromAllList(0);
    if (level4Songs.length == 0) {
      if (level3Songs.length == 0) {
        if (level2Songs.length == 0) {}
      }
    }
  }

  void _suggestFirstSong() {
    int maxLevelPoint;

    maxLevelPoint = level1Songs[0].level1;
    level2Songs.addAll(level1Songs.takeWhile((value) {
      if (value.level1 == maxLevelPoint) {
        return true;
      } else {
        return false;
      }
    }));
    level2Songs.sort(level2Comparison);
    print('Level2 list: ${level2Songs.length}');

    maxLevelPoint = level2Songs[0].level2;
    level3Songs.addAll(level2Songs.takeWhile((value) {
      if (value.level2 == maxLevelPoint) {
        return true;
      } else {
        return false;
      }
    }));
    level3Songs.sort(level3Comparison);
    print('Level3 list: ${level3Songs.length}');

    maxLevelPoint = level3Songs[0].level3;
    level4Songs.addAll(level3Songs.takeWhile((value) {
      if (value.level3 == maxLevelPoint) {
        return true;
      } else {
        return false;
      }
    }));
    level4Songs.sort(level4Comparison);
    print('Level4 list: ${level4Songs.length}');
    print('Level 2 songs');
    for (int i = 0; i < level2Songs.length; i++) {
      print(level2Songs[i].songNameEnglish);
    }
    print('Level 3 songs');
    for (int i = 0; i < level3Songs.length; i++) {
      print(level3Songs[i].songNameEnglish);
    }
    print('Level 4 songs');
    for (int i = 0; i < level4Songs.length; i++) {
      print(level4Songs[i].songNameEnglish);
    }
  }

  void _populateLevel2List(int maxLevelPoint) {
    maxLevelPoint = level1Songs[0].level1;
    level2Songs.addAll(level1Songs.takeWhile((value) {
      if (value.level1 == maxLevelPoint) {
        return true;
      } else {
        return false;
      }
    }));
    level2Songs.sort(level2Comparison);
    print('Level2 list: ${level2Songs.length}');
  }

  void _populateLevel3List() {}

  void _populateLevel4List() {}

  void _removeSuggestedSongFromAllList(int index) {
    int removalIndex = level4Songs
        .indexWhere((song) => song.code == suggestedSongs[index].code);
    if (removalIndex > -1) {
      level4Songs.removeAt(removalIndex);
    }
    removalIndex = level3Songs
        .indexWhere((song) => song.code == suggestedSongs[index].code);
    if (removalIndex > -1) {
      level3Songs.removeAt(removalIndex);
    }
    removalIndex = level2Songs
        .indexWhere((song) => song.code == suggestedSongs[index].code);
    if (removalIndex > -1) {
      level2Songs.removeAt(removalIndex);
    }
    removalIndex = level1Songs
        .indexWhere((song) => song.code == suggestedSongs[index].code);
    if (removalIndex > -1) {
      level1Songs.removeAt(removalIndex);
    }
  }

  void _populateLevel1List() {
    for (int index = 0; index < sortedSongList.length; index++) {
      if ((!songsVisited.contains(sortedSongList[index].code))) {
        bool toExclude = false;
        _currentStreakLevels.forEach((level, map) {
          int totalKeys = 0;
          int totalPresent = 0;
          map.forEach((key, value) {
            totalKeys++;
            if (value == 'category' &&
                sortedSongList[index].category.toLowerCase().contains(key)) {
              totalPresent++;
            } else if (value == 'code' && sortedSongList[index].code == key) {
              totalPresent++;
            } else if (value == 'genre' &&
                sortedSongList[index].genre.toLowerCase().contains(key)) {
              totalPresent++;
            } else if (value == 'language' &&
                sortedSongList[index].language.toLowerCase().contains(key)) {
              totalPresent++;
            } else if (value == 'singer' &&
                sortedSongList[index].singer.toLowerCase().contains(key)) {
              totalPresent++;
            } else if (value == 'originalSong' &&
                sortedSongList[index]
                    .originalSong
                    .toLowerCase()
                    .contains(key)) {
              totalPresent++;
            } else if (value == 'tirthankar' &&
                sortedSongList[index].tirthankar.toLowerCase().contains(key)) {
              totalPresent++;
            } else if (key == 'favourite' && sortedSongList[index].isLiked) {
              totalPresent++;
            } else if (key == 'popular' &&
                sortedSongList[index].popularity > 110) {
              totalPresent++;
            }
          });
          double levelPoint = (totalPresent / totalKeys) * 100;
          if (totalKeys == 0) {
            levelPoint = 100;
          }
          if (level == 0 && totalKeys > 0 && levelPoint > 0) {
            toExclude = true;
          }
          if (level == 1) {
            sortedSongList[index].level1 = levelPoint.round();
          } else if (level == 2) {
            sortedSongList[index].level2 = levelPoint.round();
          } else if (level == 3) {
            sortedSongList[index].level3 = levelPoint.round();
          } else if (level == 4) {
            sortedSongList[index].level4 = levelPoint.round();
          }
        });
        if (toExclude == false) {
          level1Songs.add(sortedSongList[index]);
        }
      }
    }
    level1Songs.sort(level1Comparison);
    print('Level1 list: ${level1Songs.length}');
  }

  //This creates the streak levels in fill it in previous streak levels map
  void _createStreakLevels(SongDetails currentSong) {
    String parameter = 'category';
    String parameterValue = currentSong.category.toLowerCase();
    parameterValue = removeSpecialChars(parameterValue);
    List<String> values = parameterValue.split(' ');

    void fillStreakValues() {
      values.forEach((value) {
        if ((!_currentStreakLevels[1].containsKey(value)) &&
            defaultStreakLevels.containsKey(value)) {
          int defaultLevel = defaultStreakLevels[value];
          _previousStreakLevels[defaultLevel][value] = parameter;
        }
      });
    }

    fillStreakValues();

    parameter = 'genre';
    parameterValue = currentSong.genre.toLowerCase();
    parameterValue = removeSpecialChars(parameterValue);
    values = parameterValue.split(' ');
    fillStreakValues();

    parameter = 'language';
    parameterValue = currentSong.language.toLowerCase();
    parameterValue = removeSpecialChars(parameterValue);
    values = parameterValue.split(' ');
    fillStreakValues();

    parameter = 'singer';
    parameterValue = currentSong.singer.toLowerCase();
    parameterValue = removeSpecialChars(parameterValue);
    values = parameterValue.split(' ');
    fillStreakValues();

    parameter = 'tirthankar';
    parameterValue = currentSong.tirthankar.toLowerCase();
    parameterValue = removeSpecialChars(parameterValue);
    values = parameterValue.split(' ');
    fillStreakValues();

    parameter = 'originalSong';
    parameterValue = currentSong.originalSong.toLowerCase();
    values = parameterValue.split(' |');
    _currentStreakLevels[0][values[0]] = parameter;

    bool isLiked = currentSong.isLiked;
    if (isLiked) {
      parameter = 'other';
      parameterValue = 'favourite';
      values = parameterValue.split(' ');
      fillStreakValues();
    }

    int popularity = currentSong.popularity;
    if (popularity > 110) {
      parameter = 'other';
      parameterValue = 'popular';
      values = parameterValue.split(' ');
      fillStreakValues();
    }
  }

  void _mergeStreakValues(SongDetails currentSong) {
    for (int level = 2; level <= 4; level++) {
      List<String> toRemove = [];
      _previousStreakLevels[level].forEach((key, value) {
        if (_currentStreakLevels[level].containsKey(key) && level > 2) {
          _currentStreakLevels[level - 1][key] = value;
          toRemove.add(key);
        } else if (!_currentStreakLevels[level].containsKey(key)) {
          _currentStreakLevels[level][key] = value;
        }
      });

      toRemove.forEach((key) {
        _currentStreakLevels[level].remove(key);
      });
    }
  }

  //This drops the streak levels which are there in current level map
  void _dropOrIncreaseStreakValues(SongDetails currentSong) {
    for (int level = 2; level <= 4; level++) {
      List<String> toRemove = [];
      _currentStreakLevels[level].forEach((key, value) {
        if (!_previousStreakLevels[level].containsKey(key)) {
          toRemove.add(key);
        }
      });

      toRemove.forEach((key) {
        _currentStreakLevels[level].remove(key);
      });
    }
  }

  //This resets the streak levels of previous song.
  void _resetStreakLevels() {
    for (int level = 2; level <= 4; level++) {
      List<String> toRemove = [];
      _currentStreakLevels[level].forEach((key, value) {
        int defaultLevel = defaultStreakLevels[key];
        if (defaultLevel > level) {
          _currentStreakLevels[defaultLevel][key] = value;
          toRemove.add(key);
        }
      });

      toRemove.forEach((key) {
        _currentStreakLevels[level].remove(key);
      });
    }
    _previousStreakLevels = {
      0: {},
      1: {},
      2: {},
      3: {},
      4: {},
    };
  }

  static Map<String, int> defaultStreakLevels = {
    'paryushan': 2,
    'diksha': 2,
    'tapasya': 2,
    'palitana': 2,
    'shikharji': 2,
    'girnar': 2,
    'bhikshu': 2,
    'aarti': 2,
    'stuti': 2,
    'chalisa': 2,
    'stotra': 2,
    'darshan': 2,
    'favourite': 3,
    'bahubali': 3,
    'chandraprabhu': 3,
    'kushal': 3,
    'munisuvrat': 3,
    'rajendra': 3,
    'shanti': 3,
    'shashan': 3,
    '24': 3,
    'stavan': 3,
    'bhakti': 3,
    'garba': 3,
    'bhavna': 3,
    'janam': 3,
    'latest': 3,
    'popular': 3,
    'trending': 3,
    'gujarati': 3,
    'simandhar': 4,
    'vasupujya': 4,
    'parshwanath': 4,
    'mahavir': 4,
    'mahaveer': 4,
    'adinath': 4,
    'adeshwar': 4,
    'neminath': 4,
    'nakoda': 4,
    'sambhavnath': 4,
    'shantinath': 4,
    'bollywood': 4,
    'hindi': 4,
    'marwadi': 4,
    'vicky': 4,
    'rsj': 4,
    'narendra': 4,
    'harshit': 4,
    'jainam': 4,
    'anjali': 4,
    'anuradha': 4,
    'jatin': 4,
    'prachi': 4,
    'sheela': 4,
    'gandhi': 4,
    'baghmar': 4,
  };

  int level1Comparison(SongDetails a, SongDetails b) {
    final propertyA = a.level1;
    final propertyB = b.level1;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }

  int level2Comparison(SongDetails a, SongDetails b) {
    final propertyA = a.level2;
    final propertyB = b.level2;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }

  int level3Comparison(SongDetails a, SongDetails b) {
    final propertyA = a.level3;
    final propertyB = b.level3;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }

  int level4Comparison(SongDetails a, SongDetails b) {
    final propertyA = a.level4;
    final propertyB = b.level4;
    if (propertyA < propertyB) {
      return 1;
    } else if (propertyA > propertyB) {
      return -1;
    } else {
      return 0;
    }
  }
}
