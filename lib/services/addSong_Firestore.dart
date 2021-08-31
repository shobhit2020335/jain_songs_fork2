import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();

  AddSong currentSong = AddSong(app);

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('TNHJV',
      englishName: 'trisla hey jug darsh dena',
      hindiName: 'महावीर जनम कल्याणक',
      originalSong: 'mahaveer janma kalayanak',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay siddhgiri siddhagiri पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment below to add song in realtimeDB.
  await currentSong.addToRealtimeDB().catchError((error) {
    print('Error: ' + error);
  }).then((value) {
    print('Added song to realtimeDB successfully');
  });
}

class AddSong {
  final FirebaseApp app;

  AddSong(this.app);

  Map<String, dynamic> currentSongMap = {
    'code': 'TNHJV',
    'album': 'Maine Pyar Kiya',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Janam Kalyanak | Bollywood',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics': 'Lyrics not available at the moment!\n',
    'englishLyrics': '',
    'originalSong': 'Dil Deewana | S P Balasubrahmanyam',
    'popularity': 0,
    'production': 'Singer Prachi Jain',
    'share': 0,
    'singer': 'Prachi Jain',
    'songNameEnglish': 'Trishla Nandan He Jag Vandan',
    'songNameHindi': 'त्रिशला नंदन हे जग वंदन',
    'tirthankar': 'Mahavir',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/IA_oqQqXgqY',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestion =
      FirebaseFirestore.instance.collection('suggestions');

  String searchKeywords = '';

  Future<void> deleteSuggestion(String uid) async {
    return suggestion.doc(uid).delete().then((value) {
      print('Deleted Successfully');
    });
  }

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void mainSearchKeywords() {
    searchKeywords = searchKeywords +
        currentSongMap['language'] +
        ' ' +
        currentSongMap['genre'] +
        ' ' +
        removeSpecificString(currentSongMap['tirthankar'], ' Swami') +
        ' ' +
        currentSongMap['category'] +
        ' ' +
        currentSongMap['songNameEnglish'] +
        ' ';
    searchKeywords = removeSpecialChars(searchKeywords).toLowerCase();
  }

  void extraSearchKeywords(
    String code, {
    String englishName: '',
    String hindiName: '',
    String tirthankar: '',
    String originalSong: '',
    String album: '',
    String extra1: '',
    String extra2: '',
    String extra3: '',
  }) {
    searchKeywords =
        searchKeywords.toLowerCase() + ' ' + englishName + ' ' + hindiName;
    searchKeywords = searchKeywords +
        ' ' +
        currentSongMap['songNameHindi'] +
        ' ' +
        currentSongMap['originalSong'] +
        ' ' +
        currentSongMap['album'] +
        ' ' +
        tirthankar +
        ' ' +
        originalSong +
        ' ' +
        album +
        ' ' +
        extra1 +
        ' ' +
        extra2 +
        ' ' +
        extra3 +
        ' ';
    List<String> searchWordsList = searchKeywords.toLowerCase().split(' ');
    searchKeywords = "";
    for (int i = 0; i < searchWordsList.length; i++) {
      if (searchWordsList[i].length > 0) {
        searchKeywords += ' ' + searchWordsList[i];
      }
    }
    currentSongMap['searchKeywords'] = searchKeywords;
    // _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  //Directly writing search keywords so not required now.
  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }

  Future<void> addToRealtimeDB() async {
    FirebaseDatabase(app: this.app)
        .reference()
        .child('songs')
        .child(currentSongMap['code'])
        .set(currentSongMap);
  }
}
