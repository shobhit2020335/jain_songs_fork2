import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('NNNNTLL',
      englishName: 'gujrati',
      hindiName: '',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'NNNNTLL',
    'album': 'Namami Nemi',
    'aaa': 'valid',
    'category': 'Song',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'नेमजी ना नाम नी तू लूट लुटिले-2,\nनेमि ना चरणें जइ बेड़ो पार करीले -2\nनेमजी ना नाम नी तू लूट लुटिले\nनेमि ना चरणें जइ बेड़ो पार करिले\n\nशरणे जाए ऐने प्रभु राह बतावे ,\nजपे नेम ऐने मोह केम सतावे ...(2)\nराजुल ना नाथ नु तू नाम रटीले-2\nनेमि ना चरणें जइ बेड़ो पार करीले -2\nनेमजी ना नाम नी तू लूट लुटिले\nनेमि ना चरणें जइ बेड़ो पार करिले\n\nध्यान धरे ऐने प्रभु ज्ञान अपावे,\nजाप जापे एना प्रभु पाप खपावे...(2)\nहितकारी नेमि ने प्रणाम करीले-2\nनेमि ना चरणें जइ बेड़ो पार करीले -2\nनेमजी ना नाम नी तू लूट लुटिले\nनेमि ना चरणें जइ बेड़ो पार करीले\n\nकृपा थाय प्रभु नी तो दोष दूर थाय,\nबंधनो जे राग ना ऐ चूर चूर थाय...(2)\nनेमी भजी संसार तमाम तजीले-2\nनेमि ना चरणें जइ बेड़ो पार करीले 2\nनेमजी ना नाम नी तू लूट लुटिले\nनेमि ना चरणें जइ बेड़ो पार करीले\n\nनेमी नाम ,नेमी नाम-2\nदिन रात सुबह शाम नेमी नाम नेमी नाम,\nपहुचाता सिद्धि धाम,नेमी नाम नेमी नाम\nतू जपले रे अविराम, नेमी नाम नेमी नाम\n नेमी नाम,नेमी नाम-9\nदिन रात सुबह शाम\nनेमी नाम ,नेमी नाम-2\n',
    'englishLyrics':
        'Nemji Na Naam Ni Tu Loot Lootile...(2)\nNemi Na Charane Jayi Bedo Paar Kari Le...(2)\nNemji Na Naam Ni Tu Loot Lootile\nNemi Na Charane Jayi Bedo Paar Kari Le\n\nSharane Jaaye Ene Prabhu Raah Batave ,\nJape Nem Ene Moh Kem Satave...(2)\nRajul Na Naath Nu Tu Naam Ratile...(2)\nNemi Na Charane Jayi Bedo Paar Kari Le\nNemji Na Naam Ni Tu Loot Lootile\nNemi Na Charane Jayi Bedo Paar Kari Le\n\nDhyan Dhare Ene Prabhu Gyaan Apave ,\nJaap Jape Ena Prabhu Paap Khapave...(2)\nHithakaari Nemi Ne Pranaam Karile...(2)\nNemi Na Charane Jayi Bedo Paar Kari Le\nNemji Na Naam Ni Tu Loot Lootile\nNemi Na Charane Jayi Bedo Paar Kari Le\n\nKrupa Thaaye Prabhu Ni to Dosh Door Thaye ,\nBandhano Je Raag Na E Choor-choor Tha...(2)\nNemi Dhwaji Sansaar Tamaam Tjajile...(2)\nNemi Na Charane Jayi Bedo Paar Kari Le\nNemji Na Naam Ni Tu Loot Lootile\nNemi Na Charane Jayi Bedo Paar Kari Le\nNemji Na Naam Ni Tu Loot Lootile\nNemi Na Charane Jayi Bedo Paar Kari Le...(2)\n\nNemi Naam Nemi Naam Nemi Naam Nemi Naam\nDin Raat Subha Shyam Nemi Naam\nPahunchata Siddhi Dhaam Nemi Naam Nemi Naam\nTu Japle Re Aviraam Nemi Naam Nemi Naam\n\nNemi Naam Nemi Naam Nemi Naam Nemi Naam...(9)\nDin Raat Ek Hi Baat\n Neminaath Neminaath\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Tattva Tarang',
    'share': 0,
    'singer': 'Jainam Varia & Various Artist',
    'songNameEnglish': 'Nemji Na Naam Ni Tu Loot Lootile',
    'songNameHindi': 'नेमजी ना नाम नी तू लूट लुटिले',
    'tirthankar': 'Neminath',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/0wsf1LCXKk4',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestion =
      FirebaseFirestore.instance.collection('suggestions');

  String searchKeywords = '';

  Future<void> deleteSuggestion(String uid) async {
    return suggestion.doc(uid).delete().then((value) {
      print('Deleted Successfully');
    });
  }

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
    searchKeywords =
        searchKeywords.toLowerCase() + ' ' + englishName + ' ' + hindiName;
    searchKeywords = searchKeywords +
        ' ' +
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
