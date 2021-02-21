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
  currentSong.makestringSearchKeyword('SUM',
      englishName: 'Sayam Usko Mile',
      hindiName: 'संयम उसको मिले',
      originalSong: 'Diksha दीक्षा',
      album: 'Sayam Usko Mile Saiyam Usko Mile Saiam Usko Mile Sayyam Usko Mile',
      tirthankar: 'Saiyiam Usko Mile Saiyyam Usko Mile Saiyyiam Usko Mile',
      extra1: 'neele gagan ke tale Humraaz 1967 Mahendra Kapoor',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा नेमिनाथ नेमीनाथ
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'SUM',
    'album': 'Humraaz (1967)',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':'हो..... संयम उसको मिले, पुण्य हों जिसके फले ।\nऐसे हैं प्राणी लाखों ही जग में, भोगों में बहते चले ।। टेर ।।\n\nमुश्किल से मानव जीवन को पाये,\nकाम करो कुछ गले ।। १ ।।\n\nकर्मों का क्षय हो, इन्द्रिय-जय हो,\nभव-भव के फेरे टले ।। २ ।।\n\nमोगों के रंग में रंगी है दुनियां,\nविषयों के झूले, झूले ।। ३ ।।\n\nविजेता बहन तो संयमी बन कर,\nवीर के पथ पे चले ।। ४ ।।\n\nत्यागी बहन को जीवन है जैसे,\nकीचड़ में कमल खिले ।। ५ ।।\n\nउज्जवल जीवन बन रहा इनका,\nप्रति के पथ पे चले ।। ६ ।।\n',
    'englishLyrics':'',
    'originalSong': 'Neele Gagan Ke Tale | Mahendra Kapoor',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': 'Mahendra Kapoor',
    'songNameEnglish': 'Saiyam Usko Mile',
    'songNameHindi': 'संयम उसको मिले',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/pSE9QzQ-EKY'
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
