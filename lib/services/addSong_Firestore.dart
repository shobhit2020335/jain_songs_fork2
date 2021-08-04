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
  currentSong.extraSearchKeywords('TECM',
      englishName: 'gujrati',
      hindiName: 'akaj akej chhe',
      originalSong: 'diksa saiyyam saiyam sanyam sayyam',
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
    'code': 'TECM',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'मिठो साध दईने ते तो मारा उघाड्या नयन\nसाचो पणथरो बताड्यो ने त्या व्हाव्या किरण …… 2\n\nतुझ स्नेहनी आ रिमझिम धारे, भिंजाई वारे वारे \nहैयुं करे छे टहूकारो\nतू एकज छे मारो (3) सथवारो\nतू एकज छे मारो ,\nप्रभु एकज तू मारो,\nतू एकज छे मारो साथवारो\n\nमुज तन मन खिले भावोमा झीले\nतू छवाई ज्यारे थईने बादरी\nमुज हैयुं नाचे तुझ शरणु याचे\nवागे ज्यारे तुझ वाणीनी वांसरि\n\nहैयुं विमल अने शीतल अंतर कोमल बने\nतारा संघ मारु मनडु स्वामी … वात्सल्य बने\nतुझ स्नेहनी आ रिमझिम धारे, भिंजाई वारे वारे \nहैयुं करे छे टहूकारो\nतू एकज छे मारो (3) सथवारो\nतू एकज छे मारो ,\nप्रभु एकज तू मारो,\nतू एकज छे मारो साथवारो\n\nवैराग्य ने समता अंतरमा रमता\nतू वस्यो जिनेश्वर हैये ज्यारथी\nसंसार किनारे झट जावु मारे\nसैयाम विना मन क्याये रमतु नथी\nतू जे जीव्यो एवु जीवन मारे जीववु हवे\nमारी झंखनामा शमनामा एक तू हवे\nतुझ स्नेहनी आ रिमझिम धरे , भिंजाई वारे वारे \nहैयुं करे छे टहूकरो .\nतू एकज छे मारो (3) सथवारो\nतू एकज छे मारो ,\nप्रभु एकज तू मारो,\nतू एकज छे मारो साथवारो\n\nके मारा मनमा तारा विना नहीं कोई रे\nके मारा दीलमा तारा विना नहीं कोई रे\nमारा…\n',
    'englishLyrics':
        'Mitho Sadh Daine Te to Mara Ughadya Nayan\nSacho Pantharo Batadyo Ne Tya Vahavya Kiran…… 2\n\nTujh Snehani Aa Rimjhim Dhare, Bhinjai Vare Vare\nHaiyu Kare Che Tahukaro\nTu Ekaj Chhe Maro (3) Sathvaro\nTu Ekaj Chhe Maro,\nPrabhu Ekaj Tu Maro,\nTu Ekaj Chhe Maro Sathvaro\n\nMujh Tan Man Khile Bhavoma Jhile\nTu Chavai Jyare Thaine Badari\nMujh Haiyu Nache Tujh Sharanu Yache\nWage Jyare Tujh Vanini Vahnsari\n\nHaiyu Vimal Ane Sheetal Antar Komal Bane\nTara Sangh Maru Mandu Swami.. Vatsalya Bane\nTujh Snehani Aa Rimjhim Dhare, Bhinjai Vare Vare\nHaiyu Kare Che Tahukaro\nTu Ekaj Chhe Maro (3) Sathvaro\nTu Ekaj Chhe Maro,\nPrabhu Ekaj Tu Maro,\nTu Ekaj Chhe Maro Sathvaro\n\nVairagya Ne Samta Antarma Ramta\nTu Vasyo Jineshwar Haiye Jyarthi\nSansar Kinare Jhat Javu Mare\nSaiyam Vina Man Kyaye Ramatu Nathi\nTu Je Jivyo Evu Jeevan Mare Jeevavu Have\nMari Jhankhanama Shamanama Ek Tu Have\nTujh Snehani Aa Rimjhim Dhare, Bhinjai Vare Vare\nHaiyu Kare Che Tahukaro\nTu Ekaj Chhe Maro (3) Sathvaro\nTu Ekaj Chhe Maro,\nPrabhu Ekaj Tu Maro,\nTu Ekaj Chhe Maro Sathvaro\n\nKe Mara Manma Tara Vina Nahi Koi Re\nKe Mara Dilma Tara Vina Nahi Koi Re\nMara…\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Anand Yatra',
    'share': 0,
    'singer': 'Keval Shah & Aman Jain',
    'songNameEnglish': 'Tu Ekaj Che Maro',
    'songNameHindi': 'तू एकज छे मारो',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/9sHqC9EjIv4',
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
