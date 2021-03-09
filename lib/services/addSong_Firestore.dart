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
  currentSong.makestringSearchKeyword('AMPHC',
      englishName: 'Ankhadi mari prabhu harkhaay che',
      hindiName: 'આંખડી મારી પ્રભુ હરખાય છે',
      originalSong: 'आंखडी मारी प्रभु हरखाय छे',
      album: 'Aankhadi mari prabhu harkhaay che',
      tirthankar: 'Aankhdi mari prabhu harkhay che',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'AMPHC',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Posh Dashmi',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'આંખડી મારી પ્રભુ હરખાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ…\n\nપગ અધીરા દોડતા દેરાસરે, (૨)\nદ્વારે પહોચું ત્યાં અજંપો જાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nદેવનું વિમાન જાણે ઉતર્યું, (૨)\nએવું મંદિર આપનું સોહાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nચાંદની જેવી પ્રતિમા આપની, (૨)\nતેજ એનું ચોતરફ ફેલાય છે.\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nમુખડું જાણે પૂનમનો ચંદ્ર મા, (૨)\nચિત્તમાં ઠંડક અનેરી થાય છે.\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n\nબસ! તમારા રૂપને નીરખ્યા કરું, (૨)\nલાગણી એવી હૃદયમાં થાય છે\nજ્યાં તમારા મુખના દર્શન થાય છે (૨)\nઆંખડી મારી પ્રભુ… (૨)\n',
    'englishLyrics':
        'Ankhadi mari prabhu harkhaay che...\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari…\n\nPag  adhiru dodtu derasare..(2)\nDware paho chu tyaa ajam khoi-jai che..\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari prabhu harkhaay che..(2)\n\nDeva nu vimaan jyaare utaryu..(2)\nEvu mandir aapnu sohay che..\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari prabhu harkhaay che..(2)\n\nBas tamara rup ne nirkhay karu..(2)\nLagni evi hraday ma thay che..\nJya tamara muk na darshan thay che ..(2)\nAnkhadi mari prabhu harkhaay che..(2)\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jinshasanam',
    'share': 0,
    'singer': 'Rupal Doshi | Kishore Manraja',
    'songNameEnglish': 'Ankhadi Mari Prabhu Harkhaay Che',
    'songNameHindi': 'આંખડી મારી પ્રભુ હરખાય છે',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/R2Z_oH7d_oU',
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
