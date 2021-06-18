import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('MRSBJL',
      englishName: '',
      hindiName: '',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'MRSBJL',
    'album': '',
    'aaa': 'valid',
    'category': 'Bhakti | Stavan',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Marwadi',
    'likes': 0,
    'lyrics':
        'मीठे रस से भरी जिनवाणी लागे, जिनवाणी लागे |\nम्हने आत्मा की बात घणी प्यारी लागे |\n\nआत्मा है उजरो उजरो, तन लागे म्हने कालो |\nशुद्ध आत्म की बात, अपने मन में बसा लो |\nम्हने चेतना की बात, घणी प्यारी लागे, मनहारी लागे |\nम्हने आत्मा की बात घणी प्यारी लागे ||(1)\n\nदेह अचेतन, मैं हूँ चेतन, जिनवाणी बतलाये |\nजिनवाणी है सच्ची माता, सच्चा मार्ग दिखाए |\nअरे मान ले तू चेतन – २, भैया कई लागे, थारो काई लागे |\nम्हने आत्मा की बात घणी प्यारी लागे ||(2)\n\nनहीं भावे म्हाने लाडू पेड़ा, नाहीं भावे काजू |\nमोक्षपूरी में जाऊँगा मैं तो बन के दिगंबर साधू |\nम्हाने मोक्ष महल को – २, मार्ग प्यारो लागे, घणो प्यारो लागे |\nम्हने आत्मा की बात घणी प्यारी लागे ||(3)\n',
    'englishLyrics': '',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': 'Shreya Ranka',
    'songNameEnglish': 'Mithe Ras Se Bhari Jinwani Lage',
    'songNameHindi': 'मीठे रस से भरी जिनवाणी लागे',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/mvmkP4sdfbw',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  String searchKeywords = '';

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
    searchKeywords = searchKeywords.toLowerCase() + englishName + hindiName;
    searchKeywords = searchKeywords +
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
    _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
