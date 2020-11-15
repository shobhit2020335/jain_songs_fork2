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
  currentSong.makestringSearchKeyword('VA',
      englishName: 'Vhala Adinath',
      hindiName: 'व्हाला आदिनाथ',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'MPK',
    'album': 'Kora Kagaz',
    'aaa': 'valid',
    'genre': 'Latest | Bhakti',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'मुक्ति पूरी के वासी जिनंदा सुनो एक अरदास (२)\nलेलो प्रभुजी ...\nलेलो प्रभुजी हमें शरण में लेकर आयो आस ।\nमुक्ति पूरी के वासी जिनंदा सुनो एक अरदास ।।\n\nऋषभ अजित संभव अभिनन्दन,\nसुमति पद्मा सुपार्श्व (२)\nचंदा सुविधि शीतल श्रेयांश,\nवासु विमल दो सुवास (२)\nअनंत धर्म ...\nअनंत धर्म शांति कुन्थु अर मल्ली मुनि की है आस ।\nमुक्ति पूरी के वासी जिनंदा सुनो एक अरदास ।। (२)\n\nनमी या नेमि अरिष्ट सिद्ध,\nपाए गढ़ गिरनार (२)\nचिंतामणी पारस प्रभुजी,\nकरुणा के अवतार (२)\nजलते नाग ...\nजलते नाग नागिन को बचाया काटी भाव की है पाश ।\nमुक्ति पूरी के वासी जिनंदा सुनो एक अरदास ।। (२)\n\nMore\nतीरथ प्राता प्रभु महावीर से,\nअर्ज गुजारे आज (२)\nविहरमान गजधर सतियांजी,\nरखना हमारी लाज (२)\nकोटी भव की ...\nकोटी भव की प्यास बुझाओ इन्द्र करे अरदास\nमुक्ति पूरी के वासी जिनंदा सुनो एक अरदास ।। (२)\n',
    'originalSong': 'Mera Jeevan Kora Kagaz | Kishore Kumar',
    'popularity': 0,
    'production': 'Saregama GenY',
    'share': 0,
    'singer': 'Kishore Kumar',
    'songNameEnglish': 'Mukti Poori Ke',
    'songNameHindi': 'मुक्ति पूरी के',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0,
    'youTubeLink': 'https://youtu.be/vmDWt1skq24'
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
