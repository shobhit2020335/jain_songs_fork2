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
  currentSong.makestringSearchKeyword('TVNR',
      englishName: 'Tara Vina Nem mane ek ladu laage',
      hindiName: 'Tara vina shyam mane ek ladu lage',
      originalSong: 'तारा विना श्याम मने तारा विना नेम मने एक लडूं लागे',
      album: 'તારા વિના શ્યામ મને',
      tirthankar: 'તારા વિના નેમ મને એક લડું લાગે',
      extra1: 'नेमिनाथ નેમિનાથ',
      extra2: 'garba',
      extra3: 'tara vina nem reprised');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'TVNR',
    'album': '',
    'aaa': 'valid',
    'category': 'Garba | Bhakti',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'तारा विना नेम मने एक लडूं लागे,\nजान जोडीने वहेलो आवजे. . . .\n\nरोज रोज तारी याद आवे,\nतारा विरहनी वेदना सतावे ( 2 ) ,\nआव्यो हुं तारे द्वार,\nमांगु छुं तारी पास ( 2 ) ,\nदरशन देवाने वहेलो आव आव आव नेम . . . तारा . . .\n\nचोरी बांधी छे चोकमां,\nदीवडा मुक्या छे गोखमां ( 2 ) ,\nतुं ना आवो तो नेम ,\nपरणुंं बीजे केम ? ( 2 ) ,\nजान जोडीने वहेलो आव आव आव नेम . . . तारा . . .\n\nनव नव भवनी आ प्रीतडी,\nराजुलनी साथे छे नेमनी ( 2 ) ,\nसतावे तुं मने केम ?\nतरछोडे तुं शाने नेम ? ( 2 )\nनव भवनो राख नेह नेह नेह नेम . . . तारा . . .\n',
    'englishLyrics':
        'તારા વિના નેમ મને એક લડું લાગે,\nજાન જોડી ને વહેલો આવજે...\n\nરોજ રોજ તારી યાદ આવે,\nતારા વિરહ ની વેદના સતાવે (2),\nઆયો હું તારે દ્વાર,\nમાંગુ છું તારી પાસ (2),\nદર્શન દેવાને વહેલો આવ આવ આવ નેમ... તારા વિના...\n\nચોરી બાંધી છે ચોક માં,\nદીવડાં મૂક્યા છે ગોખ માં (2),\nતું ના આવે તો નેમ,\nપરણું હું બીજે કેમ? (2),\nજાન જોડી ને વહેલો આવ આવ આવ નેમ... તારા વિના...\n\nનવ નવ ભવની આ પ્રીતડી,\nરાજુલ ની સાથે છે નેમની (2),\nસતાવે તું મને કેમ?\nતરછોડે તું શાને નેમ? (2),\nનવ ભવનો રાખ નેહ નેહ નેહ નેહ... તારા વિના...\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Prabhu Panth',
    'share': 0,
    'singer': 'Manthan Shah',
    'songNameEnglish': 'Tara Vina Nem Reprised',
    'songNameHindi': 'तारा विना नेम',
    'tirthankar': 'Neminath Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/j0T68sNzWpM',
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
