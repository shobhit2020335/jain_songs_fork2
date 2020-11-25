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
  currentSong.makestringSearchKeyword('AKMSTM',
      englishName: 'Aa Kal Ma Sadhu Thanara Mahan',
      hindiName: 'आ काल मा साधु थनारा महान',
      originalSong: 'Diksha',
      album: 'दिक्षा',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'AKMSTM',
    'album': '',
    'aaa': 'valid | Original Song',
    'genre': 'Diksha Stavan',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'यौवन वैमा सुख छोडनारा महान,\nआ कदम साधु थनारा महान (२)\n\nयौवन नु पतन करावे एवो छे आ समय (२)\nविषयो नु व्यसन करावे एवो छे आ समय (२)\nआवा समय माँ सगड़ी वासनाओ जितिन (२)\nमैंनेः विरागमा वाद्नारा महान (२)\nआ काल मा साधु थनारा महान…\nसाधु थनारा महान (४)\n\nनमस्कार अंगारने, जिनशषण शृंगारने (२)\nनमस्कार अंगारने (२)\nनमो लोए सव्वा साहूणं (२)\nआ काल मा साधु थनारा महान…\n\nजेने गुरु कनैठी तत्वों ग्रैहम करया (२)\nशाश्त्रोमाही रहेला सत्यो श्रवण करया (२)\nभावमा भमादनारा करमोथि छुटवा (२)\nसंयम भनी कदम मांडणारा महान\nआ काल मा साधु थनारा महान…\n\nआ काल मा साधु थनारा महान…\nयौवन वैमा सुख छोडनारा महान,\nआ काल मा साधु थनारा महान… (2)\n',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Aa Kal Ma Sadhu Thanara Mahan',
    'songNameHindi': 'आ काल मा साधु थनारा महान',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/g5JZD4tOHaE'
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
