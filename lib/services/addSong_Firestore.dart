import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('KKHH',
      englishName: 'alka yagnik filmy',
      hindiName: 'शत्रुंजय shatrunjay पालीताना पालीताणा',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'KKHH',
    'album': 'Kuch Kuch Hota Hai',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Palitana | Bollywood',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'तेरे बिना मेरी ज़िन्दगी\nपतझर सी थी मेरी हर घडी (2)\nतूने ओ दादा जी इनको\nसींच दिया\nसींच दिया\nप्यार का तू सागर\nरेहमत का बादल\nतू ही मेरी नाव का मांझी\nतू ही सहारा (२)\n\nतेरे दार पे आया\nतुमको ही ध्याया\nतुमसे ही दादा मैंने प्रीत लगाया\nअब तोह मेरा दिल\nतुमको ही ध्याता है\nक्या करू दादा\nकुछ कुछ होता है\nक्या करू दादा कुछ कुछ होता है\n\nअंधियारी राहो पे दीपक जला\nरोशन किया मेरा ये जहाँ (२)\nतुमसे ही साँझ होती दादा\nतुमसे सुबह.. तुमसे सुबह\n\nसांसो की सरगम\nतुझसे ही चलती है\nएक तू ही दादा\nअंकित का साथी है\nएक तू ही दादा\nअंकित का साथी है\n\nतेरे दार पे आया\nतुमको ही ध्याया\nतुमसे ही दादा मैंने प्रीत लगाया\n\nअब तोह मेरा दिल\nतुमको ही ध्याता है\nक्या करू दादा\nकुछ कुछ होता है\nक्या करू दादा कुछ कुछ होता है....\n',
    'englishLyrics':
        'Tere Bina Meri Zindagi\nPaatjhar Se Thi Meri Har Ghadi (2)\nTune Oh Dada Ji Inko\nSinch Diya\nSinch Diya\nPyar Ka Tu Sagar\nRehmat Ka Badal\nTu Hi Meri Naav Ka Manjhi\nTu Hi Sahara (2)\n\nTere Dar Pe Aya\nTujhko Hi Dhyaya\nTumse Hi Dada Maine Preet Lagaya\n\nAb Toh Mera Dil\nTujhko Hi Dhyata Hai\nKya Karu Dada\nKuch Kuch Hota Hai\nKya Karu Dada\nKuch Kuch Hota Hai\n\nAndhiyari Raho Pe Deepak Jala\nRoshan Kiya Mera Ye Jahan (2)\nTumse Hi Saanjh Hoti Dada\nTumse Subha Tumse Subha\n\nSanso Ki Sargam\nTujhse Hi Chalti Hai\n Ek Tu Hi Dada\nAnkit Ka Sathi Hai\nEk Tu Hi Dada\nAnkit Ka Sathi Hai\n\nTere Dar Pe Aya\nTujhko Hi Dhiyaya\nTumse Hi Dada Maine Preet Lagaya\n\nAb Toh Mera Dil\nTujhko Hi Dhyata Hai\nKya Karu Dada\nKuch Kuch Hota Hai\nKya Karu Dada\nKuch Kuch Hota Hai….\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Singer Ankit Lodha',
    'share': 0,
    'singer': 'Ankit Lodha',
    'songNameEnglish': 'Kuch Kuch Hota Hai',
    'songNameHindi': 'कुछ कुछ होता है',
    'tirthankar': 'Aadinath Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/GgC5MaJBBrA',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  String searchKeywords = '';

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void mainSearchKeywords() {
    searchKeywords = searchKeywords +
        currentSongMap['language'] +
        ' ' +
        currentSongMap['genre'] +
        ' ' +
        removeSpecificString(currentSongMap['tirthankar'], ' Swami') +
        ' ' +
        currentSongMap['category'] +
        ' ' +
        currentSongMap['songNameEnglish'] +
        ' ';
    searchKeywords = removeSpecialChars(searchKeywords).toLowerCase();
  }

  void extraSearchKeywords(
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
    searchKeywords = searchKeywords.toLowerCase() + englishName + hindiName;
    searchKeywords = searchKeywords +
        currentSongMap['songNameHindi'] +
        ' ' +
        currentSongMap['originalSong'] +
        ' ' +
        currentSongMap['album'] +
        ' ' +
        tirthankar +
        ' ' +
        originalSong +
        ' ' +
        album +
        ' ' +
        extra1 +
        ' ' +
        extra2 +
        ' ' +
        extra3 +
        ' ';
    _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
