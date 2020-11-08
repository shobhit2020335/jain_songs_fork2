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
  currentSong.makeListOfStrings('UUS',
      englishName: 'Uncha Uncha Shatrunjay',
      hindiName: 'ऊंचा ऊंचा शत्रुंजयनां',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: 'शत्रुंजयनां',
      extra2: 'Shatrunjay');
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'UUS',
    'album': '',
    'aaa': 'valid',
    'genre': 'Stavan | Bhajan',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'ऊंचा ऊंचा शत्रुंजयनां शिखरो सोहाय,\nवच्चे मारा दादा केरा केरा जगमग थाय... - ऊंचा…\n\nदादा तारी यात्रा करवा, मारुं मन ललचाय (२),\nतळेटीए शीश नमावी, चढवा लागुं पाय (२), - ऊंचा…\n\nपावनगिरिनो, स्पर्श थातां, पापो दूर पलाय..\nलीली लीली झाडीओमां, पंखी करे कलशोर (२), - ऊंचा…\n\nसोपान चढताने, हैयुं जाणे, अषाढियानो मोर (२)\nकांकरे कांकरे सिद्धा अनंता, लळी लळी लागुं पाय... - ऊंचा…\n\nपहेली आवे रामपोळने, त्रीजी वाघणपोळ (२),\nशांतिनाथनां दर्शन करीए, पहोंच्या हाथीपोळ (२), - ऊंचा…\n\nसामे मारा, दादा केरा, दरबार देखाय...\nदोडी दोडी आवुं दादा दर्शन करवाने काज (२), - ऊंचा…\n\nभाव भरीने भक्ति करुं, साधु आतम काज (२),\nमाता मरू (देवी) नां, नंदन भेटी, जीवन पावन थाय... - ऊंचा…\n\nक्षमाभावे ॐकार पदनुं, जपीश हुं तो जाप (२),\nदादा तारा गुणला गातां, कापीश भवनां पाप (२),\nपद्मविजय’नां, हैये आजे, आनंद उभराय... - ऊंचा…\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Shemaroo Jai Jinendra',
    'share': 0,
    'singer': 'Harsh dedhia',
    'songNameEnglish': 'Uncha Uncha Shatrunjay',
    'songNameHindi': 'ऊंचा ऊंचा शत्रुंजयनां',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0,
    'youTubeLink': 'https://youtu.be/a4c4n1Hkg5g'
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
