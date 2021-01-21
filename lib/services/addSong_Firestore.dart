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
  currentSong.makestringSearchKeyword('TKKH',
      englishName: 'Tapasya Karta Karta Ho Ke Danka',
      hindiName: 'तपस्या करता करता हो',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'TKKH',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Tapasya',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':'तपस्या करता करता हो के,\nडंका जोर बजाया हो..\n\nतपस्या करता करता हो के,\nडंका जोर बजाया हो..\n\nउजमणा तप केरां करता,\nशासन सोह चढाया हो;\nवीर्य उल्लास वधे तेने कारण,\nकर्म निर्जरा पाया\nतपस्या…\n\nअडसिद्धि अणिमा लचिमादिक,\nतिम लब्धी अडवीसा हो;\nविष्णुकुमारादिक परे जगमां,\nपावत जयंत जगीशा\nतपस्या…\n\nगौतम अष्टापदगीरी चढीया,\nतापस आहार कराया हो;\nते तप कर्म निकाचित तपवे,\nक्षमा सहित मुनिराया\nतपस्या…\n\nसाडा बार वर्ष जिन उत्तम,\nवीरजी भूमि न ठाया हो;\nघोर तपे केवल लाह्या तेहना,\nपद्मविजय नमे पाया\nतपस्या…\n',
  'englishLyrics':'',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jain Sargam',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Tapasya Karta Karta Ho',
    'songNameHindi': 'तपस्या करता करता हो' ,
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/Y2An7hwy4LA'
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
