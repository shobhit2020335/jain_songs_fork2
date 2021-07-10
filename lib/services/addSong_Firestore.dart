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
  currentSong.extraSearchKeywords('MM',
      englishName: 'mahaveer manglam',
      hindiName: 'sonu nigam  ',
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
    'code': 'MM',
    'album': '',
    'aaa': 'valid',
    'category': 'Stuti',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi | Sanskrit',
    'likes': 0,
    'lyrics':
        'जय जय जय महावीर (8)\n\nमहावीर मंगलम धीर गंभीर मंगलम (5)\nपावन भगवन महावीर मंगलम (२)\n\nसत्य अहिंसा परम करम वरदान मंगलम\nजीव दया धन जैन धर्म सुख दान मंगलम\nमहावीर का पूजन अर्चन भी है मंगलम\nमानवता  की सेवा वर्धमान मंगलम\nमहावीर मंगलम धीर गंभीर मंगलम\nपावन भगवन महावीर मंगलम (२)\n\n\nचैत्र शुक्ल की तेरस का दिन मान मंगलम\nसन्नति देने वाली है अति वीर मंगलम\nजैनो की चौबीसवें तीर्थंकर मंगलम\nदेव धरम का काम है जिनेन्द्र मंगलम\nमहावीर मंगलम धीर गंभीर मंगलम\nपावन भगवन महावीर मंगलम (२)\n\nपंच अणुव्रत महादान सिद्धांत मंगलम\nत्रिशला माँ सिद्धार्थ पिता के तनय मंगलम\nमहावीर जी देव का प्रगटन है मंगलम\nश्रद्धा भक्ति भगवन का नाम स्मरण मंगलम\nमहावीर मंगलम धीर गंभीर मंगलम\nपावन भगवन महावीर मंगलम (२)\n\nराज भोग वैभव विलास परित्याग मंगलम\nसरल सादगी गरिमामय जीवन है मंगलम\nब्रह्मचर्य की श्रेष्ठ तपस्या भी है मंगलम\nनिज अपराधों की क्षमा प्राथना  है मंगलम\nमहावीर मंगलम धीर गंभीर मंगलम\nपावन भगवन महावीर मंगलम (२)\n\nमहावीर जी कहते है धर्मात्मा मंगलम\nसदाचार माया ममता करुणा है मंगलम\nशांति अहिंसा आत्म नियंत्रण में है मंगलम\nआत्म सिद्ध कर स्वयं विजय करना है मंगलम\nमहावीर मंगलम धीर गंभीर मंगलम\nपावन भगवन महावीर मंगलम (२)\n\nजय जिनेन्द्र जय जय जिनेन्द्र कहना है मंगलम\nजीव जीव से मित्र भाव रखना है मंगलम\nत्रिगुणात्मक  सत्पुरषो का सम्मान मंगलम\nअपनी काया मन वाचा जीतना है मंगलम\nमहावीर मंगलम धीर गंभीर मंगलम\nपावन भगवन महावीर मंगलम (5)\n',
    'englishLyrics':
        'Jai Jai Jai Mahaveer (8)\n\nMahaveer Mangalam Dhir Gambhir Mangalam (5)\nPawan Bhagwan Mahaveer Mangalam (2)\n\nSatya Ahinsa Param Karam Vardan Mangalam\nJeev Daya Dhan Jain Dharm Sukh Daan Mangalam\nMahaveer Ka Poojan Archan Bhi Hai Mangalam\nManavta Ki Sewa Vardhaman Mangalam\nMahaveer Mangalam Dhir Gambhir Mangalam\nPawan Bhagwan Mahaveer Mangalam (2)\n\nChaitra Shukla Ki Teras Ka Din Mann Mangalam\nSannati Dene Wali Hai Ati Veer Mangalam\nJaino Ki Chaubeesve Tirthankar Mangalam\nDev Dharam Ka Kaam Hai Jinendra Mangalam\nMahaveer Mangalam Dhir Gambhir Mangalam\nPawan Bhagwan Mahaveer Mangalam (2)\n\nPanch Anuvrat Mahadaan Siddhant Mangalam\nTrishla Maa Siddharth Pita Ke Tanay Mangalam\nMahaveer Ji Dev Ka Pragatan Hai Mangalam\nShraddha Bhakti Bhagwan Ka Naam Smaran Mangalam\nMahaveer Mangalam Dhir Gambhir Mangalam\nPawan Bhagwan Mahaveer Mangalam (2)\n\nRaj Bhog Vaibhav Vilas Parityaag Mangalam\nSaral Sadagi Garima Mai Jeevan Hai Mangalam\nBrahmacharya Ki Shreshtha Tapasya Bhi Hai Mangalam\nNij Apradho Ki Kshama Prathana Hai Mangalam\nMahaveer Mangalam Dhir Gambhir Mangalam\nPawan Bhagwan Mahaveer Mangalam (2)\n\nMahaveer Ji Kehte Hai Dharmatma Mangalam\nSadachar Maya Mamta Karuna Hai Mangalam\nShanti Ahimsa Aatma Niyantran Mein Hai Mangalam\nAatma Siddh Kar Swayam Vijay Karna Hai Mangalam\nMahaveer Mangalam Dhir Gambhir Mangalam\nPawan Bhagwan Mahaveer Mangalam (2)\n\nJai Jinendra Jai Jai Jinendra Kehna Hai Mangalam\nJeev Jeev Se Mitra Bhaav Rakhna Hai Mangalam\nTrigunatmak Satpursho Ka Samman Mangalam\nApni Kaya Man Wacha Jeetna Hai Mangalam\nMahaveer Mangalam Dhir Gambhir Mangalam\nPawan Bhagwan Mahaveer Mangalam (5)\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Times Music Spiritual',
    'share': 0,
    'singer': 'Sonu Nigam',
    'songNameEnglish': 'Mahavir Mangalam',
    'songNameHindi': 'महावीर मंगलम',
    'tirthankar': 'Mahavir Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/EEKZsQ7iOAs',
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
