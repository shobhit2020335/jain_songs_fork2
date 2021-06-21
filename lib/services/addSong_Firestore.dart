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
  currentSong.extraSearchKeywords('ASDIJK',
      englishName: 'भगवन तुम्हारे चरणों में',
      hindiName: 'Nemnath Bhagwan Tumhare Charno Me',
      originalSong: 'नेमनाथ भगवन तुम्हारे चरणों में',
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
    'code': 'ASDIJK',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'अब सौप दिया इस जीवन को\nभगवन तुम्हारे चरणों में…\nनेमनाथ तुम्हारे चरणों में…\nमैं हु शरणागत प्रभु तेरा\nरहे ध्यान तुम्हारे चरणों में\nअब सौप दिया इस जीवन को\nभगवन तुम्हारे चरणों में\n\nमेरा निश्चय प्रभु बस एक वही\nमैं तुम चरणों का पुजारी बनु\nअर्पण कर दू दुनिया भर का (2)\nसब प्यार तुम्हारे चरणों में\nमैं हु शरणागत प्रभु तेरा\nरहे ध्यान तुम्हारे चरणों में\nअब सौप दिया इस जीवन को\nभगवन तुम्हारे चरणों में\n\nजहा तक संसार में भ्रमण करू\nतुज चरणों में जीवन को धरु (२)\nतुम स्वामी , मैं सेवक तेरा (२)\nधरु ध्यान तुम्हारे चरणों में…\nमैं हु शरणागत प्रभु तेरा\nरहे ध्यान तुम्हारे चरणों में\nअब सौप दिया इस जीवन को\nभगवन तुम्हारे चरणों में\nमेरी इच्छा प्रभु बस एक वही\nएक बार तुझे मैं मिल जाऊ\nइस सेवक की हर रग रग का\nहो तार तुम्हारे हाथो में\nमैं हु शरणागत प्रभु तेरा\nरहे ध्यान तुम्हारे चरणों में\nअब सौप दिया इस जीवन को\nभगवन तुम्हारे चरणों में\n\nमैं हु शरणागत प्रभु तेरा\nरहे ध्यान तुम्हारे चरणों में\nअब सौप दिया इस जीवन को\nभगवन तुम्हारे चरणों में\nनेमनाथ तुम्हारे चरणों में…\nनेमनाथ तुम्हारे चरणों में…\n',
    'englishLyrics':
        'Ab Saup Diya Is Jeevan Ko\nBhagwan Tumhare Charno Me…\nNemnath Tumhare Charno Me…\nMain Hu Sharanagat Prabhu Tera\nRahe Dhyaan Tumhare Charno Me\nAb Saup Diya Is Jeevan Ko\nBhagwan Tumhare Charno Me\n\nMera Nischay Prabhu Bus Ek Wahi\nMain Tum Charno Ka Pujari Banu\nArpan Kar Du Duniya Bhar Ka (2)\nSab Pyaar Tumhare Charno Me\nMain Hu Sharnagat Prabhu Tera\nRahe Dhyan Tumhare Charno Me\nAb Saup Diya Is Jeevan Ko\nBhagwan Tumhare Charno Me\n\nJaha Tak Sansaar Me Bhraman Karu..\nTuj Charno Me Jeevan Ko Dharu..\nTum Swami, Main Sevak Tera…(2)\nDharu Dhyaan Tumhare Charno Me…\nMain Hu Sharnagat Prabhu Tera\nRahe Dhyaan Tumhare Charno Me\nAb Saup Diya Is Jeevan Ko\nBhagwan Tumhare Charno Me\n\nMeri Icha Prabhu Bus Ek Wahi\nEk Baar Tujhe Main Mil Jaau\nIs Sevak Ki Har Rag Rag Ka\nHo Taar Tumhaare Haatho Me\nMain Hu Sharnagat Prabhu Tera\nRahe Dhyaan Tumhare Charno Me\nAb Saup Diya Is Jeevan Ko\nBhagwan Tumhaare Charno Me\n\nMain Hu Sharnagat Prabhu Tera\nRahe Dhyaan Tumhare Charno Me\nAb Saup Diya Is Jeevan Ko\nBhagwan Tumhare Charno Me\nNemnath Tumhare Charno Me..\nNemnath Tumhare Charno Me…\n',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': 'Paras Gada',
    'songNameEnglish': 'Ab Saup Diya Is Jeevan Ko',
    'songNameHindi': 'अब सौप दिया इस जीवन को',
    'tirthankar': 'Neminath Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/PcegrJIhLAM',
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
