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
  currentSong.makestringSearchKeyword('SSMHT',
      englishName: 'Sambhav Saheb Maro Hu Taro',
      hindiName: 'संभव साहिब मारो हुं ताहरो',
      originalSong: '',
      album: '',
      tirthankar: 'Sambhavnath Swami',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'SSMHT',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':'संभव साहिब मारो हुं ताहरो, सेवक सिरदार कि\nमहेर करी मुज-उपरे उतारो, भव सायर पार कि\nसंभव… (१)\n\nआनन अद्दभुत चंदले, तें मोह्यों, मुज नयण चकोर कि\nमनडुं मिलवा तुमहैं प्रभुजीस्युं, जिम मेहां मोर कि\nसंभव… (२)हुं नि गुणो पण तारीए, गुण अवगुण मत आणो चित्त कि\nबांह्य गह्यां निरवाहीए सु सनेही, सयणांनी रीत कि\nसंभव… (३)\n\nसार संसारे ताहरी, प्रभु सेवा, सुखदायक देव कि\nदिल धरी दरसण दीजीए तुम ओलग, कीजीयें नित्यमेव कि\nसंभव… (४)\n\nचोतीस अतिशय सुंदरु, पुरंदर, सेवे चित लाय कि\nरूचिर प्रभुजी पय सेवता सुख संपत्ति, अति आणंद थाय कि\nसंभव… (५)\n',
    'englishLyrics':'',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Sambhav Saheb Maro Hu Taro',
    'songNameHindi': 'संभव साहिब मारो हुं ताहरो' ,
    'tirthankar': 'Sambhavnath Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': ''
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
