import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.makestringSearchKeyword('LLL',
      englishName: 'Lori Lori Lori Trishala Mata Ra Laadla',
      hindiName: 'lori lori lori Trishla Mata Ra Ladla',
      originalSong: 'लोरी लोरी लोरी त्रिशला माता रा लाडला',
      album: '',
      tirthankar: 'Rowdy Rathore Chandaniya Shreya Ghoshal',
      extra1:
          'महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'LLL',
    'album': 'Rowdy Rathore',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Janam Kalyanak | Latest',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'Lori Lori Lori…(4)\nTrishala Mata Ra Laadla\nAur Tu Sidhharath Shangara\nNindiya Aankho Mein Aaye\nVardhaman Mera Sojaye….\nLeke God Mein Sulavu\nGaavu Raat Bhar Sunavu\nMein Lori Lori….\nLori Lori Lori…(4)\n\nRatna Maniro Maro Parno\nSaav Sonari Dor Ro\nDevi Devta Nar Naari\nThane Zhulave Sabhi\nLeke God Mein Sulavu\nGaavu Raat Bhar Sunavu\nMein Lori Lori….\nLori Lori Lori…(4)\n\nMaa Trishala Gaave Loriya\nDhire Dhire Podho Mara Vira…..\nChappandik Kunwari Aave\nNav Nava Geeto Gaave\nLeke God Mein Sulavu\nGaavu Raat Bhar Sunavu\nMein Lori Lori….\nLori Lori Lori…(4)\n',
    'englishLyrics': '',
    'originalSong': 'Chandaniya | Shreya Ghoshal',
    'popularity': 0,
    'production': 'Music Of Jainism',
    'share': 0,
    'singer': 'Jainam Varia',
    'songNameEnglish': 'Lori Lori Lori (Trishala Mata Ra Laadla)',
    'songNameHindi': 'लोरी लोरी लोरी (त्रिशला माता रा लाडला)',
    'tirthankar': 'Mahavir Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/jFV8xyiMeBo',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void makestringSearchKeyword(
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
    String currentString;
    currentString = englishName.toLowerCase() + ' ' + hindiName.toLowerCase();
    currentString = currentString +
        ' ' +
        tirthankar.toLowerCase() +
        ' ' +
        originalSong.toLowerCase() +
        ' ' +
        album.toLowerCase() +
        ' ' +
        extra1.toLowerCase() +
        ' ' +
        extra2.toLowerCase() +
        ' ' +
        extra3.toLowerCase();
    _addSearchKeywords(code, currentString);
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
