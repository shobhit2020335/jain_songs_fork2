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
  currentSong.extraSearchKeywords('RMTPJ',
      englishName: 'vandan tara charan ma to tu',
      hindiName: 'ragi mate tyaage tyage panthi jaye jaaye',
      originalSong: 'gujrati',
      album: '',
      tirthankar: '',
      extra1: 'રાગી મટી ત્યાગી પંથે જાય',
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
    'code': 'RMTPJ',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha | Latest',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'वंदन तारा चरणमां तुं,\nरागी मटी त्यागी पंथे जाय.. (२)\nश्रमण बनी.. नवकार मंत्रमां समाय..\nसघळा संसारने भीतरथी विसरी.. (२)\nवैरागी रंगे रंगाय.. रागी मटी त्यागी पंथे जाय..\nवंदन तारा चरणमां..\n\nसंग साहेबनो, रंग वैराग्य नो,\nसत्संग सद् गुरुदेवनो.. (२)\nत्याग राग संगनो, राग श्वेत रंग नो,\nभाव मळे श्री वितरागनो… (२)\nभीतरे संयम लहेराय.. रागी मटी त्यागी पंथे जाय..\nवंदन तारा चरणमां..\n\nनेम गमे वीर गमे, राजुलनु गीत गमे,\nगौतम झलके तारी आंखमां.. (२)\nचंदनानी प्रीत गमे, सुलसा नी रीत गमे,\nरेवती धबके धबकारमां.. (२)\nकर्मो कठिन करमाय.. रागी मटी त्यागी पंथे जाय..\nवंदन तारा चरणमां..\n',
    'englishLyrics':
        'વંદન તારા ચરણમાં તું,\nરાગી મટી ત્યાગી પંથે જાય.. (૨)\nશ્રમણ બની.. નવકાર મંત્રમાં સમાય..\nસઘળા સંસારને ભીતરથી વિસરી.. (૨)\nવૈરાગી રંગે રંગાય.. રાગી મટી ત્યાગી પંથે જાય..\nવંદન તારા ચરણમાં..\n\nસંગ સાહેબનો, રંગ વૈરાગ્ય નો,\nસત્સંગ સદ્ ગુરુદેવનો.. (૨)\nત્યાગ રાગ સંગનો, રાગ શ્વેત રંગ નો,\nભાવ મળે શ્રી વિતરાગનો… (૨)\nભીતરે સંયમ લહેરાય.. રાગી મટી ત્યાગી પંથે જાય..\nવંદન તારા ચરણમાં..\n\nનેમ ગમે વીર ગમે, રાજુલનુ ગીત ગમે,\nગૌતમ ઝલકે તારી આંખમાં.. (૨)\nચંદનાની પ્રીત ગમે, સુલસા ની રીત ગમે,\nરેવતી ધબકે ધબકારમાં.. (૨)\nકર્મો કઠિન કરમાય.. રાગી મટી ત્યાગી પંથે જાય..\nવંદન તારા ચરણમાં..\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Param Path',
    'share': 0,
    'singer': 'Shail Shah',
    'songNameEnglish': 'Raagi Mati Tyagi Panthe Jaay',
    'songNameHindi': 'रागी मटी त्यागी पंथे जाय',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/2w37ylRl8ZY',
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
