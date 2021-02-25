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
  currentSong.makestringSearchKeyword('OCA',
      englishName: 'Beni Chhod Chali Sansaar',
      hindiName: 'जा संयम पंथे दीक्षार्थी',
      originalSong: 'Diksha दीक्षा',
      album: 'दीन दुखीया नो तु छे बेली',
      tirthankar:'Din Dukhiya No Tu Chhe Beli',
      extra1: 'Din Dukhiya No Tu Che Beli',
      extra2: 'Beni Chod Chali Sansar',
      extra3: 'बेनी छोड चली संसार');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा नेमिनाथ नेमीनाथ
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'BCCS',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':'संसारना सह वैभव छोडी, राख्या कुल ना नाम,\nबेनी छोड चली संसार…\n\nजान भी है पहचान भी है, वो चली गुरूजी के पास,\nबेनी छोड चली संसार…\n\nआये सूरिजी लाने चेलीजी, ले गये वैरागण को साथ,\nदेखो कैसा रीब रीराज, वेनी छोड चली संसार...\n\nजातानी रोवे पिता भी रोदे, भैया करे रे पुकार,\nबेनी छोड चली संसार…\n\nसाई गी रोपे मानी भी गये, भतीजा करे रे पुकार,\nभुआ छोड चली संसार…\n\nवहन भी रोवे बहनोईशा भी रोवे, भाणेजा करे रे पुकार,\nमासी छोड चली संसार…\n\nसखिया भी रोवे सहेलियां भी रोवे, पर्खासी करे रे पुकार,\nबेनी छोड चली संसार…\n',
    'englishLyrics':'',
    'originalSong': 'Din Dukhiya No Tu Chhe Beli',
    'popularity': 0,
    'production': 'Jain Sargam',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Beni Chhod Chali Sansaar',
    'songNameHindi': 'बेनी छोड चली संसार',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/fp8ywWt1CTY'
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
