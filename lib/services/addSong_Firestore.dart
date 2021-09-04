import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();

  AddSong currentSong = AddSong(app);

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('JKTA',
      englishName: 'ab tak kiye jo paap pap vo dhone',
      hindiName: 'tiyohar tyohaar pajushan parushan paryusan',
      originalSong: 'pajyushan',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  // pajushan parushan paryusan pajyushan
  //शत्रुंजय shatrunjay siddhgiri siddhagiri पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment below to add song in realtimeDB.
  await currentSong.addToRealtimeDB().catchError((error) {
    print('Error: ' + error);
  }).then((value) {
    print('Added song to realtimeDB successfully');
  });
}

class AddSong {
  final FirebaseApp app;

  AddSong(this.app);

  Map<String, dynamic> currentSongMap = {
    'code': 'JKTA',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Paryushan',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'अब तक किए जो पाप वो, धोने का वक्त आया\nभक्ति , तप और साधना करने का वक्त आया\nआया पर्युषण आया\nजैनो का त्यौहार आया\nजैनो का त्यौहार आया\n\nजैन धर्म के सार को समझने का वक्त आया\nक्षमावीरस्य भूषणम कहने का वक्त आया\nआया पर्युषण आया\nजैनो का त्यौहार आया\nजैनो का त्यौहार आया\n\nबैर हटाओ सबको खमाओ\nकरदो क्षमा और कर्म खपाओ (२)\nगुरुवाणी सुनकर दोष मिटाओ\nकल्प सूत्र सुनकर आनंद पाओ\n\nएकाशना करो, करो व्यासना\nतेला करो और तपसाधना\nसब पर्वों का राजा है आया\nजैनो का त्यौहार आया\nजैनो का त्यौहार आया\n\nअब तक किए जो पाप वो, धोने का वक्त आया\nभक्ति , तप और साधना करने का वक्त आया\nआया पर्युषण आया\nजैनो का त्यौहार आया\nजैनो का त्यौहार आया\n\nमिच्छामि दुक्कडम करलो प्रतिक्रमण\nआत्म हित हो पुलकित हो ये मंन (२)\nमंदिर में स्थानक में समय गुज़ारो\nये आठ दिन तो मोह माया तोड़ो (२)\n\nगर तुम करो ये साधना\nसंवत्सरी क्षमा याचना\nबस जिनवाणी बनजाए साया\nजैनो का त्यौहार आया\nजैनो का त्यौहार आया\n\nअब तक किए जो पाप वो, धोने का वक्त आया\nभक्ति , तप और साधना करने का वक्त आया\nआया पर्युषण आया\nजैनो का त्यौहार आया\nजैनो का त्यौहार आया (6)\n',
    'englishLyrics':
        'Aab Tak Kiye Jo Paap Wo, Dhone Ka Wakt Aaya\nBhakti, Tap Aur Sadhna Karne Ka Wakt Aaya\nAaya Paryushan Aaya…\nJaino Ka Tyohar Aaya\nJaino Ka Tyohar Aaya\n\nJain Dharma Ke Saar Ko Samajhne Ka Wakt Aaya\nShamaveerasya Bhushanam Kehna Ka Wakt Aaya\nAaya Paryushan Aaya\nJaino Ka Tyohar Aaya\nJaino Ka Tyohar Aaya\n\nBair Hatao Sabko Khamao\nKardo Shama Aur Karma Khapao (2)\nGuruwani Sunkar Dosh Mitawo\nKalpa Sutra Sunkar Anand Pao\n\nEkashana Karo Karo Vyasana\nTela Karo Aur Tapasadhana\nSab Parvo Ka Raja Hai Aaya\nJaino Ka Tyohar Aaya\nJaino Ka Tyohar Aaya\n\nAab Tak Kiye Jo Paap Wo, Dhone Ka Wakt Aaya\nBhakti, Tap Aur Sadhna Karne Ka Wakt Aaya\nAaya Paryushan Aaya…\nJaino Ka Tyohar Aaya\nJaino Ka Tyohar Aaya\n\nMicchami Dukadam Karlo Pratikraman\nAatam Hit Ho Pulkit Ho Ye Mann (2)\nMandir Mein Sthanak Mein Samai Guzaro\nYe Aath Din Toh Moh Maaya Todo (2)\n\nGar Tum Karo Ye Sadhana\nSamvatsari Din Shama Yachana\nBass Jinvani Banajaye Saaya\nJaino Ka Tyohar Aaya\nJaino Ka Tyohar Aaya\n\nAab Tak Kiye Jo Paap Wo, Dhone Ka Wakt Aaya\nBhakti, Tap Aur Sadhna Karne Ka Wakt Aaya\nAaya Paryushan Aaya…\nJaino Ka Tyohar Aaya\nJaino Ka Tyohar Aaya (6)\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Vicky D Parekh',
    'share': 0,
    'singer': 'Vicky D Parekh & Devyani Karve Kothari',
    'songNameEnglish': 'Jaino Ka Tyohar Aaya (Paryushan Aaya)',
    'songNameHindi': 'जैनो का त्यौहार आया (पर्युषण आया)',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/DRTHbJeyYkM',
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
    List<String> searchWordsList = searchKeywords.toLowerCase().split(' ');
    searchKeywords = "";
    for (int i = 0; i < searchWordsList.length; i++) {
      if (searchWordsList[i].length > 0) {
        searchKeywords += ' ' + searchWordsList[i];
      }
    }
    currentSongMap['searchKeywords'] = searchKeywords;
    // _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  //Directly writing search keywords so not required now.
  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }

  Future<void> addToRealtimeDB() async {
    FirebaseDatabase(app: this.app)
        .reference()
        .child('songs')
        .child(currentSongMap['code'])
        .set(currentSongMap);
  }
}
