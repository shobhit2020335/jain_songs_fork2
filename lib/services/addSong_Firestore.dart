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
  currentSong.makestringSearchKeyword('MVAM',
      englishName: ' મોતી વેરાના ચોક માં આવ્યા શ્રી જિનરાજ',
      hindiName: 'मोती वेराना चौक मा आव्या श्री जिनराज',
      originalSong: 'Moti Veraana Aangan Ma Moti verana Angan ma',
      album:
          'Moti Veraana (Re Aavya Tapasvi) Moti verana aangan ma aavya tapasvi',
      tirthankar: 'Latest tapasya geet',
      extra1: 'Amit Trivedi',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'MVAM',
    'album': 'Songs Of Faith',
    'aaa': 'valid',
    'category': 'Garba',
    'genre': 'Latest | Tapasya',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'Ho tame utsav aaje mandavo\n Tame utsav aaje mandavo \nMangal geeto gavo aaje sharnai-dhol vagado\n\nHo mara tapasvi aavya aaje\nHo mara tapasvi aavya aaje\nJai Jai nad gajavo bhai, tapni dhoom machavo\n\nMoti veraana aanganma aavya tapasvi\nHaiya harshit thay re aavya tapasvi\nRe aavya tapasvi (2)\n\nAkshat fulade vadhaavo re aavya tapasvi\nJin Shasan sohaay, re aavya tapasvi\n\nTame aangan aaje sajavo\nTame aangan aaje sajavo\nAso Palavna toran bandhavo\nShasan devi vadhavo\n\nHo aaje avsar rudo aavyo\nHo aaje avsar rudo aavyo\nManna manorat poora thaata,\nTapasvi man harkhayo\n\nMoti veraana aanganma aavya tapasvi\nHaiya harshit thay re aavya tapasvi\nRe aavya tapasvi (2)\n\nAkshat fulade vadhaavo re aavya tapasvi\nJin Shasan sohaay, re aavya tapasvi\nRe aavya tapasvi…(2)\n',
    'englishLyrics': '',
    'originalSong': 'Moti Veraana (Amit Trivedi)',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': 'Gautam Baria',
    'songNameEnglish': 'Moti Veraana (Re Aavya Tapasvi)',
    'songNameHindi': 'मोती वेराना चौक मा (आव्या श्री जिनराज)',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/Wy28Xo551ws',
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
