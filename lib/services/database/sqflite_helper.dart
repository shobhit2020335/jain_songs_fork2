import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../useful_functions.dart';

class SQfliteHelper {
  static Future<Database>? database;

  static Future<void> initializeSQflite() async {
    //First copying Database file from asset to internal storage.
    bool isFileFound = false;

    //Constructing fiel path to copy database to
    Directory? applicationDirectory = await getApplicationDocumentsDirectory();
    String path = join(applicationDirectory.path, 'songs_database.db');

    //Copying file if not found.
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      try {
        ByteData data =
            await rootBundle.load(join('assets', 'songs_database.db'));
        List<int> bytes =
            data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);

        await File(path).writeAsBytes(bytes);
        print('Database file copied from asset to internal storage');
        isFileFound = true;
      } catch (e) {
        print('Error copying database to internal Storage: $e');
        isFileFound = false;
      }
    } else {
      isFileFound = true;
      print('Database file exists in internal storage');
    }

    database = openDatabase(
      join(applicationDirectory.path, 'songs_database.db'),
      //Creates the TABLE for first time.
      onCreate: (db, version) {
        if (isFileFound == false) {
          print('Creating database because not found in internal storage');
          return db.execute(SongDetails.createSongTable);
        }
      },
      onUpgrade: (db, oldVersion, newVerison) {
        if (isFileFound == false) {
          print('Creating database because not found in internal storage');
          return db.execute(SongDetails.createSongTable);
        }
      },
      version: 1,
    );
  }

  //Inserts song to SQflite.
  Future<bool> insertSong(SongDetails song) async {
    final db = await database;

    try {
      int position = await db!.insert('songs', song.toMapForSQflite(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      if (position <= 0) {
        print('Couldnt insert song in SQflite, Position: $position');
        return false;
      }
      print('Song added in SQflite: ${song.code}');
      return true;
    } catch (e) {
      print('Error inserting song to SQflite: $e');
      return false;
    }
  }

  Future<bool> deleteDatabase() async {
    final db = await database;
    db!.delete('songs');
    return true;
  }

  Future<bool> fetchSongs() async {
    final Database? db = await database;
    print('Fetching Songs from sqlite');

    try {
      List<Map<String, dynamic>> songs =
          await db!.query('songs', orderBy: 'code ASC');
      if (songs.length == 0) {
        return false;
      }
      ListFunctions.songList.clear();
      await _readFetchedSongs(songs, ListFunctions.songList);
      return true;
    } catch (e) {
      print('Error fetching songs from SQflite: $e');
      return false;
    }
  }

  Future<void> _readFetchedSongs(
      List<Map<String, dynamic>> songs, List<SongDetails?> listToAdd) async {
    for (Map<String, dynamic> currentSong in songs) {
      String state = currentSong['aaa'];
      state = state.toLowerCase();
      if (state.contains('invalid') != true) {
        SongDetails currentSongDetails = SongDetails(
            album: currentSong['album'],
            code: currentSong['code'],
            category: currentSong['category'],
            genre: currentSong['genre'],
            gujaratiLyrics: currentSong['gujaratiLyrics'],
            language: currentSong['language'],
            lyrics: currentSong['lyrics'],
            englishLyrics: currentSong['englishLyrics'],
            songNameEnglish: currentSong['songNameEnglish'],
            songNameHindi: currentSong['songNameHindi'],
            originalSong: currentSong['originalSong'],
            popularity: currentSong['popularity'],
            production: currentSong['production'],
            searchKeywords: currentSong['searchKeywords'],
            singer: currentSong['singer'],
            tirthankar: currentSong['tirthankar'],
            todayClicks: currentSong['todayClicks'],
            totalClicks: currentSong['totalClicks'],
            trendPoints: currentSong['trendPoints'],
            likes: currentSong['likes'],
            share: currentSong['share'],
            youTubeLink: currentSong['youTubeLink']);
        bool? valueIsliked = await SharedPrefs.getIsLiked(currentSong['code']);
        if (valueIsliked == null) {
          SharedPrefs.setIsLiked(currentSong['code'], false);
          valueIsliked = false;
        }
        currentSongDetails.isLiked = valueIsliked;
        String songInfo =
            '${currentSongDetails.tirthankar} | ${currentSongDetails.genre} | ${currentSongDetails.singer}';
        currentSongDetails.songInfo = trimSpecialChars(songInfo);
        if (currentSongDetails.songInfo.length == 0) {
          currentSongDetails.songInfo = currentSongDetails.songNameHindi!;
        }
        listToAdd.add(
          currentSongDetails,
        );
      }
    }
  }

  Future<bool> changeClicks(SongDetails currentSong) async {
    //Algorithm is not used here, it is used in firestore side because firestore
    //is updated first.
    final db = await database;
    try {
      await db?.update(
        'songs',
        {
          'popularity': currentSong.popularity,
          'todayClicks': currentSong.todayClicks,
          'totalClicks': currentSong.totalClicks,
          'trendPoints': currentSong.trendPoints,
        },
        where: 'code = ?',
        whereArgs: [currentSong.code],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Updated clicks in SQLite');
      return true;
    } catch (e) {
      print('Error Updating clicks in SQflite: $e');
      return false;
    }
  }
}
