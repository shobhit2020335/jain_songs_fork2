import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../useful_functions.dart';

class SQfliteHelper {
  static Database? database;

  static Future<void> initializeSQflite() async {
    //First copying Database file from asset to internal storage.
    bool isFileFound = false;

    if (await _requestPermission(Permission.storage)) {
      //Constructing fiel path to copy database to
      Directory? applicationDirectory = await getExternalStorageDirectory();
      String path = join(applicationDirectory!.path, 'songs_database.db');

      //TODO: XXX: Commented this to create db file directly to external storage,
      //changed: Directory? applicationDirectory = await getApplicationDocumentsDirectory();
      //to
      //Copying file if not found.
      // if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      //   try {
      //     ByteData data =
      //         await rootBundle.load(join('assets', 'songs_database.db'));
      //     List<int> bytes =
      //         data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);

      //     await File(path).writeAsBytes(bytes);
      //     print('Database file copied from asset to internal storage');
      //     isFileFound = true;
      //   } catch (e) {
      //     print('Error copying database to internal Storage: $e');
      //     isFileFound = false;
      //   }
      // } else {
      //   isFileFound = true;
      //   print('Database file exists in internal storage');
      // }

      database = await openDatabase(
        path,
        //Creates the TABLE for first time.
        onCreate: (db, version) {
          if (isFileFound == false) {
            print('Creating database because not found in internal storage');
            db.execute(SongDetails.createSongTable);
          }
        },
        onUpgrade: (db, oldVersion, newVerison) async {
          if (isFileFound == false) {
            print('Creating database because it might be deleted');
            await db.execute(SongDetails.createSongTable);
          } else if (isFileFound && newVerison > oldVersion) {
            print('Deleting file and copying new file');
            await File(path).delete();
            try {
              ByteData data =
                  await rootBundle.load(join('assets', 'songs_database.db'));
              List<int> bytes = data.buffer
                  .asInt8List(data.offsetInBytes, data.lengthInBytes);

              await File(path).writeAsBytes(bytes);
              print('Database file copied from asset to internal storage');
              isFileFound = true;
            } catch (e) {
              print('Error copying database to internal Storage: $e');
              isFileFound = false;
            }
          }
        },
        //XXX: Increase version when there is change in database schema
        version: 1,
      );
    } else {
      print('Permission not granted');
    }
  }

  //This requests permission for storage or anything.
  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> deleteSong(String code) async {
    final db = database;

    print('deleting song: $code');
    db!.delete('songs', where: 'code = ?', whereArgs: [code]);
  }

  //Song is called for update from firestore which are modified.
  Future<bool> updateSong(
    Map<String, dynamic> currentSong,
  ) async {
    final db = database;

    try {
      print('upadting song in sqflite: ${currentSong['code']}');
      Timestamp? timestamp = currentSong['lastModifiedTime'];
      await db!.update(
        'songs',
        {
          'aaa': currentSong['aaa'].toString(),
          'album': currentSong['album'].toString(),
          'category': currentSong['category'].toString(),
          'genre': currentSong['genre'].toString(),
          'gujaratiLyrics': currentSong['gujaratiLyrics'].toString(),
          'language': currentSong['language'].toString(),
          'lyrics': currentSong['lyrics'].toString(),
          'englishLyrics': currentSong['englishLyrics'].toString(),
          'songNameEnglish': currentSong['songNameEnglish'].toString(),
          'songNameHindi': currentSong['songNameHindi'].toString(),
          'originalSong': currentSong['originalSong'].toString(),
          'production': currentSong['production'].toString(),
          'searchKeywords': currentSong['searchKeywords'].toString(),
          'singer': currentSong['singer'].toString(),
          'tirthankar': currentSong['tirthankar'].toString(),
          'youTubeLink': currentSong['youTubeLink'].toString(),
          'lastModifiedTime': timestamp?.millisecondsSinceEpoch,
        },
        where: 'code = ?',
        whereArgs: [currentSong['code'].toString()],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error updating song in SQflite: $e');
      return false;
    }
  }

  //Inserts song to SQflite.
  Future<bool> insertSong(SongDetails song) async {
    final db = database;

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
    final db = database;
    db?.delete('songs');
    return true;
  }

  Future<bool> fetchSongs() async {
    final Database? db = database;
    print('Fetching Songs from sqlite');

    try {
      bool isSuccess = false;
      List<Map<String, dynamic>> songs =
          await db!.query('songs', orderBy: 'code ASC');
      ListFunctions.songList.clear();
      isSuccess = await _readFetchedSongs(songs, ListFunctions.songList);
      return isSuccess;
    } catch (e) {
      print('Error fetching songs from SQflite: $e');
      return false;
    }
  }

  Future<bool> _readFetchedSongs(
      List<Map<String, dynamic>> songs, List<SongDetails?> listToAdd) async {
    try {
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
            youTubeLink: currentSong['youTubeLink'],
            lastModifiedTime: currentSong['lastModifiedTime'],
          );
          bool? valueIsliked =
              await SharedPrefs.getIsLiked(currentSong['code']);
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
      return true;
    } catch (e) {
      print("error reading songs from sqlite: $e");
      return false;
    }
  }

  Future<bool> changeClicks(SongDetails currentSong) async {
    //Algorithm is not used here, it is used in firestore side because firestore
    //is updated first.
    final db = database;
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
      return true;
    } catch (e) {
      print('Error Updating clicks in SQflite: $e');
      return false;
    }
  }

  Future<bool> changeShare(SongDetails currentSong) async {
    final db = database;
    try {
      await db?.update(
        'songs',
        {
          'share': currentSong.share,
        },
        where: 'code = ?',
        whereArgs: [currentSong.code],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error updating likes in SQflite: $e');
      return false;
    }
  }

  Future<bool> changeLikes(SongDetails currentSong) async {
    final db = database;
    try {
      await db?.update(
        'songs',
        {
          'popularity': currentSong.popularity,
          'likes': currentSong.likes,
          'isLiked': currentSong.isLiked,
        },
        where: 'code = ?',
        whereArgs: [currentSong.code],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error updating likes in SQflite: $e');
      return false;
    }
  }
}
