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
  currentSong.extraSearchKeywords('EMEC',
      englishName: 'Gujrati diksa eek manurath eevo chhe',
      hindiName: '',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  // pajushan parushan paryusan pajyushan bhairav parasnath parshwanath
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
    'code': 'EMEC',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'एक मनोरथ एवो छे, वेष श्रमणनो लेवो छे,\nप्रभु चरणोमां रहेतुं छे, संयम मारे लेवू छे,\nअंतरनी एक प्यास छ, संयमनी अभिलाष छे...1\n\nभवभ्रमणा दूर टळजो रे, पंथ प्रभुनो मळजो रे,\nअरजी ए अवधारजो, संयम जीवन आपजो,\nजाग्या छे एवा अरमान, श्रमण धर्मनुं देजो दान...2\n\nभवोभवनो हुं प्यासी छु, संयमनो अभिलाषी छु,\nसाद मारो सांभळजो रे, मारग तारो मळजो रे,\nवीर प्रभुनो अंश मळे, गुरु गौतमनो वंश मळे...3\n\nसंयम मारे लेवु छे, भवथी पार उतरतुं छे,\nरोमरोमथी प्रगटे नाद, संयमना द्यो आशीर्वाद,\nएक झंखना जागी छे, संयम भिक्षा माँगी छे...4\n\nकरुणा करजो ओ किरतार, संयम देजो जगदाधार,\nउरना आसन खाली छे, दीक्षा मुजने व्हाली छे,\nवरसोथी मीट मांडु छु, संयम भिक्षा मांगु छु,\nएक मनोरथ एवो छे, वेष श्रमणनो लेवो छे...5\n',
    'englishLyrics':
        'Ek Manorath Evo Che Vesh Shraman No Levo Che..(4)\nPrabhu Charano Ma Revu Che Saiyam Mare Levu Che..(4)\nAntar Ni a Pyaas Vhe Saiyam Ni Abhilaash Che...(4)\n\nBhavbhramana Dur Tadajo Re Panth Prabhuno Madajo Re..(4)\nAraji a Avadhaarjo Saiyam Jeevan Aapjo..(4)\nJaagya Che Eva Aramaan Shraman Dharma Nu Dejo Daan..(4)\n\nBhavbhavno Hu Pyaasi Chu Saiyam No Abhilaashi Chu..(4)\nSaath Maro Sambhadjo Re Marag Taro Madjo Re..(4)\nVeer Prabhu No Ansh Made Guru Gautam No Vansh Made..(4)\n\nSaiyam Mare Levu Che Bhavthi Paar Utarvu Che..(4)\nRom Rom Thi Pragate Naad Saiyam Na Dyo Aashirwad..(4)\nEk Jhankhana Jagi Che Saiyam Bhiksha Magi Che..(4)\n\nKaruna Karjo O Kirtaar Saiyam Dejo Jag Aadhaar..(4)\nUrana Aasan Khali Che Diksha Mujne Vhali Che..(4)\nVaraso Thi Mit Mandu Chu Saiyam Jeevan Maangu Chu..(4)\n\nEk Manorath Evo Che Vesh Shraman No Levo Che\nPrabhu Charano Ma Revu Che Saiyam Mare Levu Che\nBhav Thi Paar Utarvu Che Vesh Shraman No Mal\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jain Stavan Official',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Ek Manorath Evo Che',
    'songNameHindi': 'एक मनोरथ एवो छे',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/Uhkxd6FBQ3Q',
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
