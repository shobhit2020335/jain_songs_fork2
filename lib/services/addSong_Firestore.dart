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
  currentSong.extraSearchKeywords('CM4S',
      englishName: 'mangalik mantar',
      hindiName: 'chatari char sharana 4 chhartari',
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
    'code': 'CM4S',
    'album': 'Manglik Mantra',
    'aaa': 'valid',
    'category': 'Stotra',
    'genre': '',
    'gujaratiLyrics':
        'ચત્તારિ મંગલં\nઅરિહંતા  મંગલં\nસિદ્ધા મંગલં\nસાહૂ મંગલં\nકેવલિ પન્નત્તો\nધમ્મો મંગલં\nચત્તારિ  લોગુત્તમા\nઅરિહંતા લોગુત્તમા\nસિદ્ધા લોગુત્તમા\nસાહૂ લોગુત્તમા\nકેવલિ પન્નત્તો\nધમ્મો લોગુત્તમો\nચત્તારિ  સરણં  પવજજામિ\nઅરિહંતે  સરણં  પવજજામિ\nસિદ્ધે સરણં  પવજજામિ\nસાહૂ સરણં  પવજજામિ\nકેવલિ પન્નત્તં\nધમમં સરણં  પવજજામિ\n',
    'language': 'Sankrit',
    'likes': 0,
    'lyrics':
        'चत्तारिमंगलम\nअरिहंत मंगल़,\nसिद्ध मंगलं,\nसाहु मंगलं,\nकेवलीपण्णत्तो धम्मो मंगलं।\nचत्तारि लोगुत्तमा\nअरिहंत लोगुत्तमा,\nसिद्ध लोगुत्तमा,\nसाहु लोगुत्तमा,\nकेवलीपण्णत्तो धम्मो लोगुत्तमा।\nचत्तारि सरणं पव्वज्जामि\nअरिहंत सरणं पव्वज्जामि,\nसिद्ध सरणं पव्वज्जामि,\nसाहु सरणं पव्वज्जामि,\nकेवलीपण्णत्तो धम्मो सरणं पव्वज्जामि।\n',
    'englishLyrics':
        'Chattari Mangalam\nArihanta Mangalam\nSiddha Mangalam\nSahu Mangalam\nKevali Pannato Dhammo Mangalam\nChattari Log utamma\nArihanta Log uttamma\nSiddha Log uttamma\nSahu Log uttamma\nKevali Pannato Dhammo Log uttama\nChattari Saranam Pavvajjami\nArihanta Saranam Pavvajjami\nSiddha Saranam Pavvajjami\nSahu Saranam Pavvajjami\nKevali Pannato Dhammo Saranam Pavvajjami\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jain Media',
    'share': 0,
    'singer': 'Foram Prasham Shah',
    'songNameEnglish': 'Chattari Mangalam (Chaar Sharna)',
    'songNameHindi': 'चत्तारि मंगलं (चार शरणा)',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/JbuYJp5ONpg',
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
