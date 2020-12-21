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
      album: 'Diksa',
      tirthankar: 'दीक्षा',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'BTMKL',
    'album': '',
    'aaa': 'valid',
    'genre': 'Bhajan',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'भगवान तुम्हे मैं खत लिखती पर पता मुझे मालूम नहीं,\nदुःख भी लिखती सुख भी लिखती पर पता मुझे मालुम नहीं,\nभगवान तुम्हे मैं खत लिखती पर पता मुझे मालूम नहीं,\n\nसूरज से पूछा चंदा से पूछा पूछा टीम टीम तारो से,\nइन सब ने कहा अम्बर में है पर पता मुझे मालुम नहीं,\nभगवान तुम्हे मैं खत लिखती पर पता मुझे मालूम नहीं,\n\nफूलो से पूछा कलियों से पुछया पूछा भाग के माली से,\nइन सब ने कहा हर डाल पे है पर पता मुझे मालुम नहीं,\nभगवान तुम्हे मैं खत लिखती पर पता मुझे मालूम नहीं,\n\nनदियों से पूछा लेहरो से पूछा पूछा बेह्ते झरनो से\nझरनो से कहा सागर में है पर पता मुझे मालुम नहीं,\nभगवान तुम्हे मैं खत लिखती पर पता मुझे मालूम नहीं,\n\nइन्से पुछा,उनसे पुछा, पूछा दुनिया के लोगो से,\nउन सब ने कहा हिरदये में है पर तुम्हने कभी ढूंढा ही नहीं,\nभगवान तुम्हे मैं खत लिखती पर पता मुझे मालूम नहीं,\n',
    'originalSong': 'Ek Phool Me Baas Nahi',
    'popularity': 0,
    'production': 'JainGuruGanesh',
    'share': 0,
    'singer': 'Sunil Parekh',
    'songNameEnglish': 'Bhagwan Tujhe Mai Khat Likhta',
    'songNameHindi': 'भगवान तुम्हे मैं खत लिखती ',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/8Ph4W8QCJgo'
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
