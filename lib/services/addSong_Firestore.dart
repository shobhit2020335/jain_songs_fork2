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

  //Uncomment below to add searchKeywords.
  currentSong.makeListOfStrings('SKKT',
      englishName: 'Saanson Ka Kya Thikana',
      hindiName: 'सांसो का क्या ठिकाना',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '');
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'SKKT',
    'album': '',
    'aaa': 'valid',
    'genre': 'Bhajan',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'सांसो का क्या ठिकाना रुक जाए चलते चलते,\nप्राणो की रौशनी भी भुज जाए चलते चलते,\nजीवन है सपन जैसा दो दिन का है बसेरा,\nआये गई मौत निश्चित ले जाए बचते बचते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते\n\nजीवन है इक तमाशा पानी में जो बताशा,\nनशवर है बून्द बून्द जो घुल जाए घुलते घुलते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते\n\nआएगा एक झोका जीवन का दीप है गुल,\nपेड़ो पे चेह चहाती निष् पंथ है ये बुलबुल,\nसांसो का क्या ठिकाना रुक जाए चलते चलते,\n\nकितने ही घर वसाये कितने ही घर उजाड़े,\nसाई रहा न रही सवासो के घटते घटते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते,\n\nअरमान लम्बे बांधे टूटे न तार सारे,\nअंतिम समय में सब ही रहे हाथ मलते मलते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते\n\nआया था हाथ खाली खाली ही हाथ जाना,\nपरिवार और प्रिये जन रह जाए रोते रोते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते\n\nस्वासो के ही सहारे जीवन के खेल सारे,\nसांसो का ये पिटारा झुक जाए झुकते झुकते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते\n\nसंवासो के तार सारे प्रभु नाम के सहारे,\nबांधे गे अमर नर मर जाए हस्ते हस्ते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते\n\nसुख पुरण स्वर अवसर बे मुख यु न खोये,\nबिक्शन भमर से तर जा प्रभु नाम रट ते रट ते,\nसांसो का क्या ठिकाना रुक जाए चलते चलते\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Yuki Audio',
    'share': 0,
    'singer': 'Rajkumar Vinayak',
    'songNameEnglish': 'Saanson Ka Kya Thikana',
    'songNameHindi': 'सांसो का क्या ठिकाना',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0,
    'youTubeLink': 'https://youtu.be/BfQOBqzR-qA'
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
