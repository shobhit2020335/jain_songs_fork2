import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
  AddSong currentSong = AddSong(currentSongMap: currentSongMap);
  await currentSong.addToFirestore();
  print('Added song successfully');
}

class AddSong {
  Map<String, dynamic> currentSongMap;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  AddSong({this.currentSongMap});

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }
}
