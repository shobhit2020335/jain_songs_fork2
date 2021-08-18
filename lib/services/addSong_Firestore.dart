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
  currentSong.extraSearchKeywords('PPL',
      englishName: 'पारसनाथ पार्श्वनाथ',
      hindiName: 'chavleshwar chaleshvar chaleshwar ',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay siddhgiri siddhagiri पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'PPL',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Marwadi',
    'likes': 0,
    'lyrics':
        'पारस प्यारा लागो, चँवलेश्वर प्यारा लागो ।\nथांकी बांकडली झाड्यां में, गैलो भूल्यो जी म्हारा पारसजी,\nम्हैं रस्तो कियां पावांला॥ पारस प्यारा … ॥\n \nअब डर लागे छै म्हाने, हर बार पुकारां थांने ।\nथांका पर्वत रा जंगल में, सिंह धडूके हो चँवलेश्वर जी,\nम्हैं रस्तो कियां पावांला॥ पारस प्यारा … ॥\n \nथे राग द्वेष न त्यागा, म्है आया भाग्या भाग्या ।\nथांका पर्वत री भाटा की, ठोकर लागी हो चँवलेश्वर जी,\nम्हैं रस्तो कियां पावांला॥ पारस प्यारा … ॥\n \nम्हे अजमेर शहर से चाल्या, थांका ऊंचा देख्या माला ।\nम्हाने पेड्या पेड्या चढवो, प्यारो लागे हो चँवलेश्वर जी,\nम्हैं रस्तो कियां पावांला॥ पारस प्यारा … ॥\n \nExtra\nथांका विशाल दर्शन पाया, जद तन मन से हरषाया ।\nथांकी छतरी की तो शोभा, न्यारी लागे हो चँवलेश्वर जी,\nम्हैं रस्तो कियां पावांला॥ पारस प्यारा … ॥\n \nथे झूंठ बोलबो छोडो, और धर्म सूं नातो जोडो ।\nम्हारी बांकडली झाड्यां में, गैलो पावो जी म्हारा सेवक जी,\nथे सीधो रस्तो पावोला॥ पारस प्यारा … ॥\n',
    'englishLyrics': 'Sandeep Bohra',
    'originalSong': '',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': 'Sandeep Bohra',
    'songNameEnglish': 'Paras Pyara Lago',
    'songNameHindi': 'पारस प्यारा लागो',
    'tirthankar': 'Parshwanath',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/wp9z9wujNlk',
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
