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
  currentSong.makestringSearchKeyword('RRHTTJC',
      englishName: 'Rome Rome Hu Taro Thati Jau Chu',
      hindiName: 'रोमे रोमे हुं तारो थतो जाउ छुं',
      originalSong: 'Rome Rome Hu Taro Thato Jav Chu',
      album: 'Rome Rome Hu Tari Thati Jau Chhu',
      tirthankar: 'Rome Rome Hu Tari Thati Jav Chu',
      extra1: 'રોમે રોમે હું તારો થતો જાઉ છું',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'RRHTTJC',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'gujaratiLyrics':
        'Suggested by:- Ruchi Gada\n\nરોમે રોમે હું તારો થતો જાઉ છું\nતારા પ્રેમમાં પ્રભુજી હું ભિંજાઉ છું\n\nહવે પરવડે નહી રહેવાનું તારાથી દૂર,\nતારે રહેવાનુ હૈયામાં હાજરા હજુર,\nતારી નજરોમાં નજરાતો જાઉ છું \nતારા પ્રેમમાં પ્રભુજી હું ભિંજાઉ છું\nરોમે રોમે હું…\n\nહવે જોડુ નહી જગમાં હું નાતો કોઇથી,\nમને વહાલો તુ વહાલો તુ વહાલો સહુથી,\nતારા યાદોમા ખોવાતો જાઉ છું \nતારા પ્રેમમાં પ્રભુજી હું ભિંજાઉ છું\nરોમે રોમે હું…\n\nહવે શરણુ દીઘુ છે તો શત રાખજે,\nઆ બાળ ને તારા શરણે રાખજે,\nવિતરાગી તારા થકી હું સોહાઉ છુ \nતારા પ્રેમમાં પ્રભુજી હું ભિંજાઉ છું…\nરોમે રોમે હું…\n',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'Suggested by:- Ruchi Gada\n\nरोमे रोमे हुं तारो थतो जाउ छुं\nतारा प्रेममां प्रभुजी हुं भिंजाउ छुं\nहवे परवडे नही रहेवानुं ताराथी दूर,\nतारे रहेवानु हैयामां हाजरा हजुर,\nतारी नजरोमां नजरातो जाउ छुं (२)\nतारा प्रेममां प्रभुजी हुं भिंजाउ छुं\nरोमे रोमे हुं…\n\nहवे जोडु नही जगमां हुं नातो कोइथी,\nमने वहालो तु वहालो तु वहालो सहुथी,\nतारा यादोमा खोवातो जाउ छुं \nतारा प्रेममां प्रभुजी हुं भिंजाउ छुं\nरोमे रोमे हुं…\n\nहवे शरणु दीघु छे तो शत राखजे,\nआ बाळ ने तारा शरणे राखजे,\nवितरागी तारा थकी हुं सोहाउ छु\nतारा प्रेममां प्रभुजी हुं भिंजाउ छुं…\nरोमे रोमे हुं…\n',
    'englishLyrics':
        'Suggested by:- Ruchi Gada\n\nRome Rome Hu Taro Thato Jau Chu\nTara Prem Maa Prabhuji Hu Bhinjau Chu\nRome Rome Hu…\nHave Parvade Nahi Rehvanu Tara Thi Dur\nTare Reh wanu Haraday Ma Hajra Hajur (2)\nTari Najaro Maa Najarato Jau Chu\nTara Prem Ma Prabhuji Hu Bhinjau Chu\nRome Rome Hu…\n\nHave Jodu Nahi Nato Hu Jag Ma Koi Thi\nMane Vhalo Tu Vhalo Tu Vhalo Sau Thi (2)\nTari Yaado Ma Khovato Jau Chu\nTara Prem Ma Prabhuji Hu Bhinjau Chu\nRome Rome Hu…\n\nHave Sharnu Lidhu Che To Sat Rakhje\nTara Baal Ne Tara Charne Rakhje (2)\nVitragi Tara Thaki Hu Sohau Chu\nTara Prem Ma Prabhuji Hu Bhinjau Chu\nRome Rome Hu…\n',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': 'Hiral Shah',
    'songNameEnglish': 'Rome Rome Hu Taro Thati Jau Chu',
    'songNameHindi': 'रोमे रोमे हुं तारो थतो जाउ छुं',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/2xZcQTIUlH4',
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
