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
  currentSong.makestringSearchKeyword('MAMPPAR',
      englishName: 'Mari Aakhon Ma Parshwa Prabhu Aavjo Re',
      hindiName: 'मारी आंखोमां पाश्व प्रभु आवजो रे',
      originalSong: 'Maari Aakon Ma Parshva Prabhu avjo Re Maari Aakon Ma shankeshwar avjo Re',
      album: 'Maari Aakon Ma Parsva Prabhu Aavjo Re Maari Aakon Ma sankeshwar Aavjo Re',
      tirthankar: 'Mari Aakon Ma Parswa Prabhu Aavjo Re Mari Aakon Ma shankheshwar Aavjo Re',
      extra1: 'Shankheshwar Parshwanath',
      extra2: 'Shankeshwar Parasnath Sankeshwar Parsvanath',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'MAMPPAR',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Stavan',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':'मारी आंखोमां पाश्व प्रभु आवजो रे,\nहुं तो पापण ना पुष्पे वधावुं\nमारा हैयाना हार बनी आवजो रे,\nहुं तो पांपण ना पुष्पे वधावुं\nमारी आंखोमां…\n\nतमे वामा देवी ना छो जाया,\nत्रण लोक मां आप छवाया (२)\nमारा मनना मंदीर मां पधारजो रे (२),\nहुं तो पांपण ना पुष्पे वधावुं\nमारी आंखोमां…\n\nभव सागर छे बहु भारी,\nझोला खाती रे नावडी मारी (२)\nनैया ना सुकानी बनी आवजो रे (२)\nहुं तो पांपण ना पुष्पे वधावुं\nमारी आंखोमां…\n\nमने मोह राजाए हराव्यो,\nमने मारग तारो भुलाव्यो (२)\nजीवनना सारथी बनी आवजो रे (२)\nहुं तो पांपण ना पुष्पे वधावुं\nमारी आंखोमां…\n\nमारा दिलमां रह्या छो आप,\nमारा मनमां चाले तारो जाप (२)\nमारा मननां मयुर बनी आवजो रे (२)\nहुं तो पांपण ना पुष्पे वधावुं\nमारी आंखोमां…\n',
    'englishLyrics':'MARI AAKHOMA PARSHWANATH AAVJO REH (2)\nHU TOH PAPANNA PUSHPEH VADHAVU,\nMARA HAIYANA HAAR BANI AAVJO REH (2)\nHU TOH PAPANNA PUSHPEH VADHAVU (2)\n\nTAME VAMADEVINA JAYA,\nTRAN LOKMA AAP CHAVAYA,(2)\nMARA MANNA..(2)\nMANDIRMA PADHARJO REH…\nHU TOH…..\n\nBHAVSAGAR CHE BAHU BHARI,\nJHOLA KHATI AA NAVADI MARI,(2)\nMARI NAIYANA..(2)\nSUKHANI BANI AAVJO REH ….\nHU TOH…..\n\nMANE MOHRAJAYE HARAVYO,\nMANE MARAG TARO BHULAVYO,(2)\nJIVANNA..(2)\nSARTHI BANI AAVJO REH…\nHU TOH…..\n\nMARA DILMA RAHYA CHO AAP,\nMARA MANNA CHALE CHE TARO JAAP,(2)\nMARA MANNA ..(2)\nMAYUR BANI AAVJO REH\nHU TOH…..\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Rajmundra Production',
    'share': 0,
    'singer': 'Dhira Salia',
    'songNameEnglish': 'Mari Aakhon Ma Parshwa Prabhu Aavjo Re',
    'songNameHindi': 'मारी आंखोमां पाश्व प्रभु आवजो रे',
    'tirthankar': 'Shankheshwar Parshwanath',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/H14jrZZ_XTo'
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
