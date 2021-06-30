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
  currentSong.extraSearchKeywords('MGMB',
      englishName: 'gujrati',
      hindiName: 'birjata birajata',
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
    'code': 'MGMB',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'He Mara Ghatama Birajata, Arihantaji,\nJinavaraji, Mahaviraji\n\nTara Darshan Karine Thayu Pavan a Man,\nTara Mukhadane Joi Thayu Jivan Dhanya,\nMara Mahavir Prabhu, He Mara Ghatama...\n\nHun to Vir Prabhuni Bhakti Re Karu (2)\nMaru Jivan Prabhu Tara Charane Dharu,\nTari Murtine Joi Dada Karu Re Naman,\nMaru Mohi Lidhu Man, He Mara Ghatama...\n\nHun to Nam Rata¸ Karu Ghadi Re Ghadi,\nHave Sambhalajo Dada Mare Bhid Re Padi,\nTari Ankhyuma Joi Chhe Premani Jhadi,\nMara Taranakaran, He Mara Ghatama...\n\nMaro Atam Banyo Chhe Aj Balabhagi\nMara Haiya Melya Chhe Sha¸agari\nTame Vahela Padharo Urana Aganiye,\nBhakto Kare Chhe Naman, He Mara Ghatama...\n',
    'englishLyrics': '',
    'originalSong': '',
    'popularity': 0,
    'production': 'Rajmudra Production',
    'share': 0,
    'singer': 'Inka Gosar & Prakash Upadhyay',
    'songNameEnglish': 'Mara Ghat Ma Birajta',
    'songNameHindi': 'मारा घट मा बिराजता',
    'tirthankar': 'Mahavir Swami & Adinath Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/SFiJg-zP4D0',
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
