import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore();
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.makestringSearchKeyword('SMSS',
      englishName: 'Sanyam Maro Swas Sanyam',
      hindiName: '',
      originalSong: 'Diksha',
      album: 'दिक्षा',
      tirthankar: 'Saiyam Maro Swas Saiyam',
      extra1: 'Sayam Maro Swas Sayam',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दिक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'SMSS',
    'album': '',
    'aaa': 'valid | Original Song',
    'genre': 'Diksha Geet | Latest',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'पर थी थया पराया, अमे स्व ना सगा थया\nसंसार नो सार समजी, परम ना पथिक थया\n\nआतम थयो ऊजागर (२)\nपरमातमा थवा\nसंयम मारो श्वास, संयम प्रभु नो अहेसास\nसंयम मारो श्वास, संयम प्रभु नो अहेसास\n\nकाया नो मेल धोवा, केटला भवो करया\nआतम नो मेल धोवा, गुरु ना चरण मल्या\nगुरु ना वचन थी जाणे (२),\nसिद्धि ना द्वार खुलया\nसंयम मारो श्वास, संयम प्रभुनो अहेसास\nसंयम मारो श्वास, संयम प्रभुनो अहेसास\n\nदुनिया नी द्रष्टि छुटी, अंतर ना नयन खुलया\nप्रभु ने पामवा हवे, पलपल तरसी रहया\nप्रीत परम नी पामवा (२),\nप्रभु ना पगले चालया\nसंयम मारो श्वास, संयम प्रभुनो अहेसास\nसंयम मारो श्वास, संयम प्रभुनो अहेसास\n\nजग मां मारुं न कोई, ऐ सत्य ने समजी गयाnआ आतम ऐक ज मारो, ऐ सत्य ने जाणी गया\nवितराग जेवा बनवा (२),\nअमे वैरागी थया\nसंयम मारो श्वास, संयम प्रभुनो अहेसास\nसंयम मारो श्वास, संयम प्रभुनो अहेसास\n\nपर थी थया पराया, अमे स्व ना सगा थया\nसंसार नो सार समजी, परम ना पथिक थया\n\nआतम थयो ऊजागर (२)\nपरमातमा थवा\nसंयम मारो श्वास, संयम प्रभु नो अहेसास\nसंयम मारो श्वास, संयम प्रभु नो अहेसास\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Ritesh Gandhi',
    'share': 0,
    'singer': 'Ritesh Gandhi',
    'songNameEnglish': 'Saiyam Maro Swas Saiyam',
    'songNameHindi': 'संयम मारो श्वास',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/00IWkbAqtao'
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
    currentString = englishName.toLowerCase() + ' | ' + hindiName.toLowerCase();
    currentString = currentString +
        ' | ' +
        tirthankar.toLowerCase() +
        ' | ' +
        originalSong.toLowerCase() +
        ' | ' +
        album.toLowerCase() +
        ' | ' +
        extra1.toLowerCase() +
        ' | ' +
        extra2.toLowerCase() +
        ' | ' +
        extra3.toLowerCase();
    _addSearchKeywords(code, currentString);
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
