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
  currentSong.makestringSearchKeyword('CJSJ',
      englishName: 'Chandan Jevu Saiyam Jivan',
      hindiName: 'चंदन जेवुं संयम जीवन',
      originalSong: 'Chandan Jevu Saiyam Jivan',
      album: 'Diksha',
      tirthankar: 'दीक्षा',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'CJSJ',
    'album': '',
    'aaa': 'valid',
    'genre': 'Diksha Geet',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'चंदन जेवुं संयम जीवन,\nजीववुं छे मारे उज्जवल जीवन\nगुरुजी करो हवे कृपा मुजपर,\nरहेवुं छे मारे संयम उपवन\nचंदन जेवुं संयम…\n\nचंदन ठंडक आपे छे,\nशीतळता प्रसरावे छे\nचंदननी छे आ विशेषता,\nएज चाहुं विशिष्टता\nचंदन सम थाये मारु जीवन,\nअर्पी दउं तुजने आ तनमन\nचंदन जेवुं संयम…\n\nकलीकाळनो आ प्रभाव छे,\nज्यां जुओ त्यां संताप छे\nसंसार घोर अंधकार छे,\nसंयम सुंदर प्रभात छे\nचंदन थकी आ शीतळता,\nरोमे रोम प्रसन्नता\nचंदन जेवुं संयम…\n\nसिद्धिगतिनी छे साधना,\nकरवी छे संयम आराधना\nगाईश तुज गुण कविता,\nपामीश हुं वीतरागता\nविज्ञानशिशुनी भावना,\nप्रियंकर थाये परमात्मा\nचंदन जेवुं संयम…\n',
    'englishLyrics':
        'Chandan jevu saiyam jivan\nJeevavu che maare ujjval jivan\nGuruji karo have krupa muj pas\n Rehavu che mare saiyam upavan\nChandan jevu saiyam jivan\nJeevavu che maare ujjval jivan\n\nChandan thandak aape che\nSheetalata prasarave che\nChandan ni che aa visheshata\nEj chahu vishishtata\nChandan sam thau maru jivan\nArpi dau tujne aa tan man\nChandan jevu saiyam jivan\nJeevavu che maare ujjval jivan\n\nKalikaal no aa prabhaav che\nJyaa juvo tya santaap che\nSansaar ghor andhakar che\nSaiyam sundar prabhat che\nChandan thaki aa sheetalta\nRome rom prasanata\nChandan jevu saiyam jivan\nJeevavu che maare ujjval jivan\n\nSiddhigati ni che sadhana\nKarvi che saiyam aaradhana\nGaais tuj gun kavita\nPamis hu vitaragata\nVigyaan shishu ni bhavna\nPriyankar thaye paramatama\nChandan jevu saiyam jivan\nJeevavu che maare ujjval jivan..\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jain Diksha',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Chandan Jevu Saiyam Jivan',
    'songNameHindi': 'चंदन जेवुं संयम जीवन',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/pbr6sikyhtY'
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
