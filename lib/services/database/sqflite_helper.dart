import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  static Future<bool> insertSong(SongDetails song) async {
    final db = await database;

    try {
      int position = await db!.insert('songs', song.toMapForSQflite(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      if (position <= 0) {
        print('Couldnt insert song in SQflite, Position: $position');
        return false;
      }
      print('Song added in SQflite');
      return true;
    } catch (e) {
      print('Error inserting song to SQflite: $e');
      return false;
    }
  }

  static Future<bool> deleteDatabase() async {
    final db = await database;
    db!.delete('songs');
    return true;
  }

  static Future<bool> fetchSongs() async {
    final Database? db = await database;
    print('Fetching Songs from sqlite');

    try {
      await db!.query('songs');
      return true;
    } catch (e) {
      print('Error fetching songs from SQflite: $e');
      return false;
    }
  }
}
