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
  currentSong.makestringSearchKeyword('TSAC',
      englishName: 'Tara Sharne Aavyo Chu Suvikari le',
      hindiName: 'तारा शरणे आव्यो छुं स्वीकारी ले',
      originalSong: 'Tara Sharne Avyo Chu Svikari le',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'TSAC',
    'album': '',
    'aaa': 'valid | Lyrics invalid | Original Song',
    'genre': 'Stavan | Bhajan',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'आव्यो छुं प्रभु तारे द्वारे…\nदर्शन दो मुक्ति दो…\nआ संसार नी माया थी…\nमुक्ति दो दर्शन दो\n\nतारा शरणे आव्यो छुं स्वीकारी ले\nमने लइ जा प्रभु तारा धाममां (२)\n\nलावी द्यो नैया प्रभजी किनारे,\nफसायो छुं हुं प्रभुजी आ चकरावे\nमारा तारणहार मने तारी ल्यो (२)\nमने लइ जा प्रभु तारा धाममां\nहो मने लइ जा…\n\nतारे मंदिरिये देवताओ आवे\nदेवताओ आवे तारी धून मचावे\nमारे प्रभु तारुं गीतडुं गावुं छे (२)\nमने लइ जा प्रभु तारा धाममां\nहो मने लइ जा…\n\nतारे मंदिरिये नोबत वागे\nनोबत वागे सौना आतम जागे\nमारे प्रभु तारी भक्तिमां भींजावुं छे (२)\nमने लइ जा प्रभु तारा धाममां\nहो मने लइ जा…\n',
    'englishLyrics':
        'Aavyo chu prabhu tara dware\nDarshan do mukti do\nAa sansar ni maya mati\nMukti do darshan do\n\nTara sharne aavyo chu swikari le\nHave laija prabhu tara dham ma..(2)\n\nTara darshan mate manadu adhir che\nTujma samau mujne etlij aas che..(2)\nMara bhav bhav na...Bandhan tu todi de..(2)\nHave laija prabhu tara dham ma..(2)\n\nTare mandir ye bhala devtao aave\nDevatao aave tari bhoomi machave\nMara tarae..Ye naak kaan jodi de\nHave laija prabhu tara dham ma..(2)\n\nTare mandir ye bhala nobath vaage\nNobath vaage sau na aatam jage..(2)\nMara taran ne har...Mane tari de..(2)\nHave laija prabhu tara dham ma..(2)\n',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Tara Sharne Aavyo Chu',
    'songNameHindi': 'तारा शरणे आव्यो छुं',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/yXJ_rCv4U1U'
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
