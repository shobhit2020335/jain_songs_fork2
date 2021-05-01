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
  currentSong.makestringSearchKeyword('KBMB',
      englishName:
          'Kyu Bhatke Mann Bawre Kyu bhatke man bavre Kyu bhatke man baavre',
      hindiName: 'क्यों भटके मन बावरे क्यों तू रोता है',
      originalSong: '',
      album: 'Mujhse Shaadi Karogi Lal Dupatta Udit Narayan & Alka Yagnik',
      tirthankar: 'Rajiv Vijayvargiya',
      extra1: 'Bollywood Bhakti',
      extra2: 'Nakoda Bheruji ka beta hokar dheeraj khota hai',
      extra3: 'भैरू जी का बेटा होकर धीरज खोता है');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'KBMB',
    'album': 'Mujhse Shaadi Karogi',
    'aaa': 'valid',
    'category': 'Bhakti | Bollywood',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'क्यों भटके मन बावरे क्यों तू रोता है\nभैरू जी का बेटा होकर धीरज खोता है..\nतू रख विश्वास ओ प्यारे वह हर पल साथ है प्यारे...\n\nउगता है गर सुबह का सूरज शाम को वह ढल जाता है\nइसी तरह जीवन में भी सुख दुख आता जाता है \nबल मांग प्रभु से जीने का.. सुख दुख के आंसू पीने का\nसुख में हंसता दुख में क्यों तु नयन भिगोता है..\nभैरू जी का बेटा.........\n\nछोड़ दिखावा चकाचौंध का काहे मनवा भरमावे\nना जाने किस रुप में तेरे सामने वह खुद आजावे\nबस नित्य लगा ले तू अर्जी.. और छोड़ प्रभु पर तू मर्जी\nभगवान की मर्जी पर क्यों न राजी होता है.. \nभैरू जी का बेटा.........\n',
    'englishLyrics':
        'Kyu bhatke man baavre kyu tu rota hai\nBheruji ka beta hokar dheeraj khota hai\nTu rakh vishwas o pyare wah har pal sath hai pyare\n\nUgta hai gar subah ka suraj\nSham ko wah dhal jaata hai.\nIsi tarah jeevan me bhi \nsukh dukh aata jaata hai\nBal mang prabhu se jeene ka.....\n\nSukh dukh ke aasu peene ka\nSukh me hasta dukh me \nkyu tu nayan bhigota hai\nBheruji ka beta...........\n\nChod dikhava chakachaundh \nKa kahe manva bharmave\nNa jaane kis roop me\nTere samne wah khud aa jave\nBas nitya laga le tu arji.......\nAur chod prabhu par tu marji\nBhagwan ki marji par \nKyu na raaji hota hai\nBheruji ka beta...........\n',
    'originalSong': 'Lal Dupatta | Udit Narayan & Alka Yagnik',
    'popularity': 0,
    'production': 'Rajiv Vijayvargiya',
    'share': 0,
    'singer': 'Rajiv Vijayvargiya',
    'songNameEnglish': 'Kyu Bhatke Mann Bawre',
    'songNameHindi': 'क्यों भटके मन बावरे',
    'tirthankar': 'Nakoda Bheruji',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/fS-rUYZ6IiM',
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
