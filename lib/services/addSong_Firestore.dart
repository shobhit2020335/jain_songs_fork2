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
  currentSong.makestringSearchKeyword('HKMAT',
      englishName: 'He kirtar mane adhar taro',
      hindiName: 'हे किरतार मने आधार तारोै',
      originalSong: 'Hey kirtar mane aadhar taro',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'HKMAT',
    'album': '',
    'aaa': 'valid',
    'genre': 'Stavan | Garba',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'हे किरतार मने आधार तारो\nजो जे ना छूटी जाय.. (२)\n\nहे प्रभु ! तारा प्रेमनो खजानो\nजो जे ना खूटी जाय.. (२)\n\nतारो आधार मने आ अवनीमां\nआपे प्रकाश ज्योत आ रजनीमां\nश्रध्धाथी बांधी छे गांठो में स्नेहनी\nजो जे ना छूटी जाय… हे किरतार…\n\nशक्ति प्रमाणे भक्ति करुं छुं\nआ जीवन तुं ज चरणे धरुं छुं\nप्रेमनी प्याली पीवा जाउं त्यां\nजो जे ना छूटी जाय… हे किरतार…\n\nगाउं छुं हे प्रभु गीत तुज प्रीतना\nस्नेहथी भरेला सुरो संगीतना\nलाख ना हीराने हाथ मांथी कोई\nजो जे ना छूटी जाय… हे किरतार…\n',
    'englishLyrics':
        'He kirtar mane aadhar taro,\njoje nā tūṭī jāy;\n\nHe Prabhu tāro premno khajāno,\njoje nā khuṭī jāy...\n\nTāro ādhār mune ā avnīmā,\nāpe prakāsh jyot rajnīmā;\nShraddhānī bāndhī chhe gānṭho me snehnī,\njoje nā chhuṭī jāy... he\n\nShakti pramāṇe bhakti karu chhu,\nā jīvan tujne charaṇe dharu chhu;\nPremnī pyālī jāu pīvā tyā,\njoje nā fūṭī jāy... he\n\nSuro sangītnā snehthī bharelā,\ngāu Prabhu gīt tuj prītnā;\nLākhnā hīrāne hāthamāthī koī,\njoje nā lūṭī jāy... he\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Rajmundra Production',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'He Kirtar Mane Aadhar Taro',
    'songNameHindi': 'हे किरतार मने आधार तारो',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/6WhacMsN_Vc'
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
