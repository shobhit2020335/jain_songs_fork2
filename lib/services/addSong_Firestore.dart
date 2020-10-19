import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();
  //Uncomment below to add a new song.

  // await currentSong.addToFirestore();
  // print('Added song successfully');

  //Uncomment below to add searchKeywords.
  currentSong.makeListOfStrings('TMB',
      englishName: 'Tu Mane Bhagwan',
      hindiName: 'तू मने भगवन',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '');
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'LAL',
    'album': '',
    'aaa': 'valid | link',
    'genre': 'Bhakti',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'मेरे दोनो हाथो में,\nऐसी लकीर है,\nदादा से मिलन होगा,\nमेरी तकदीर है,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख।।\n\nलिखता है लिखने वाला,\nसोच समझ कर,\nमिलना बिछुड़ना दादा,\nहोता समय पर,\nइसमे मीन न मेख दादा,\nइसमे मीन न मेख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख।।\n\nकिस्मत का लेख कोई,\nमिटा नही पायेगा,\nकैसे मिलन होगा,\n समय ही बताएगा,\nमिटती नही है रेख दादा,\nमिटती नही है रेख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख।।\n\nन वो दिन रहे ना,\nये दिन रहेंगे,\nदादा तुम देख लेना,\nजल्दी मिलेंगे,\nइन हाथो को देख दादा,\nइन हाथो को देख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख।।\n\nकुंजन तेरी शरण में आया,\nआकर के चरणों में,\nशीश नवाया,\nइन भक्तो को देख दादा,\nइन भक्तो को देख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख।।\n\nमेरे दोनो हाथो में,\nऐसी लकीर है,\nदादा से मिलन होगा,\nमेरी तकदीर है,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख,\nलिखा है ऐसा लेख दादा,\nलिखा है ऐसा लेख।।\n',
    'originalSong': 'Unknown',
    'production': '',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Likha Hai Aisa Lekh (Mere Dono Hatho Me)',
    'songNameHindi': 'लिखा है ऐसा लेख (मेरे दोनो हाथो में)',
    'tirthankar': '',
    'youTubeLink': ''
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void makeListOfStrings(
    String code, {
    String englishName: '',
    String hindiName: '',
    String tirthankar: '',
    String originalSong: '',
    String album: '',
    String extra1: '',
    String extra2: '',
  }) {
    Set<String> setSearchKeywords = {};

    String currentString = '';
    for (int i = 0; i < englishName.length; i++) {
      currentString = currentString + englishName[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < hindiName.length; i++) {
      currentString = currentString + hindiName[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < tirthankar.length; i++) {
      currentString = currentString + tirthankar[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < album.length; i++) {
      currentString = currentString + album[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < originalSong.length; i++) {
      currentString = currentString + originalSong[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < extra1.length; i++) {
      currentString = currentString + extra1[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < extra2.length; i++) {
      currentString = currentString + extra2[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }

    _addSearchKeywords(code, setSearchKeywords.toList());
  }

  void _addSearchKeywords(String code, List<String> listSearchKeywords) async {
    await songs.doc(code).update({'searchKeywords': listSearchKeywords});
    print('Added Search Keywords successfully');
  }
}
