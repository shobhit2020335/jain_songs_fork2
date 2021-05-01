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
  currentSong.makestringSearchKeyword('APJR',
      englishName: 'Aise Palna Jhule Re Rishabh Sambhav Jain RSJ',
      hindiName: '',
      originalSong:
          'Kabir Singh Mere Sohneya | Parampara Thakur & Sachet Tandon',
      album: '',
      tirthankar: '',
      extra1:
          'महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'APJR',
    'album': 'Kabir Singh',
    'aaa': 'valid',
    'category': 'Bhakti',
    'genre': 'Latest | Janam Kalyanak',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'रेशम की हाय डोरी चमके जैसे चाँद सितारे\nछोटे से महावीरा की हाय कोई नज़र उतारे\nऐसे पलना झूले रे\nके जैसे कोई चाँद को छुले रे\n\nतीनो लोक में हो जैसे कोई शादी रे\nसारी दुनिया से आये हो बाराती रे\nलाल है आया\nखुशीआं है लाया\nदिल में समाया !!\nआँखें टॉम- टॉम- तमके रे\nहो जैसे सारे तारे चमके रे\nऐसे पलना झूले रे......!!\n\nजैसे अंगना में बाजे शहनाई रे\nआयी ख़ुशी वाली घड़ियाँ आयी रे\nलाल है आया\nखुशियां है लाया\nदिल में समाया !!\nआँखें टॉम - टॉम - तमके रे\nहो जैसे सारे तारे चमके रे\nऐसे पलना झूले रे.....!!!!\n\nछोटे से महावीरा.....!!!\n',
    'englishLyrics':
        'Resham ki haye dori chamke jaise chaand sitaare\nChhote se mahaveera ki haye koi nazar utaare\nAise palna jhule re\nKe jaise koi chaand ko chule re\n\nTeeno lok me ho jaise koi shaadi re\nSaari duniya se aaye ho baraati re\nLaal hai aaya \nKhushiaan hai laaya\nDil me samaaya !!\nAankhein tam- tam- tamke re\nHo jaise saare taare chamke re\nAise palna jhule re......!!\n\nJaise angana me baaje shehnaai re\nAayi khushi waali ghadiyaan aayi re\nLaal hai aaya\nKhushiyaan hai laaya\nDil me samaaya !!\nAankhein tam - tam - tamke re\nHo jaise saare taare chamke re\nAise palna jhule re.....!!!!\n\nChote se mahaveera.....!!!\n',
    'originalSong': 'Mere Sohneya | Parampara Thakur & Sachet Tandon',
    'popularity': 0,
    'production': 'Bhakti Bhavna',
    'share': 0,
    'singer': 'Rishabh Sambhav Jain (RSJ)',
    'songNameEnglish': 'Aise Palna Jhule Re',
    'songNameHindi': '',
    'tirthankar': 'Mahavir Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/KaAP2uYBSn0',
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
