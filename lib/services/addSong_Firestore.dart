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
  currentSong.extraSearchKeywords('JCB',
      englishName: 'Rishabh Sambhav Jain RSJ',
      hindiName: 'रात नामुमकिन है',
      originalSong: 'chand bena Raat Namumkin rat',
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
    'code': 'JCB',
    'album': 'Dhadkan',
    'aaa': 'valid',
    'category': '',
    'genre': 'Latest | Bollywood',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'जैसे चाँद बिना रात नामुमकिन है\nमेरी हर एक सांस अधूरी तुम बिन है (२)\nमै फकीरों सा तेरे दर आता हूँ\nजिस जगह देखु तुझी को पाता हूँ\nजैसे चाँद बिना रात नामुमकिन है\nमेरी हर एक सांस अधूरी तुम बिन है\n\nतू ही भक्ति है मेरी हर रोज़ मै करलु\nनाम को तेरे प्रभु हर रोज़ में जापलू\nतू मेरी मंज़िल तू ही मंज़िल का है जरिया\nजो बहे आखों से तू वो आँख का दरिया\n\nजैसे बिन आंसू आँख नामुम्कीम है\nमेरी हर एक सांस अधूरी तुम बिन है\nजैसे चाँद बिना रात नामुमकिन है\n.मेरी हर एक सांस अधूरी तुम बिन है\n\nक्यों तेरे दर के सीवा कहीं और जाऊ मै\nतेरे ही आगे प्रभु ये सर झुकाऊं मै\nमै मुसाफिर हूँ भटकता तू ठिकाना है\nमै हूँ छोटा सा शहर तू तो ज़माना है\n\nजैसे भाव बिना दर्श नामुमकिन है\nमेरी हर एक सांस अधूरी तुम बिन है\nजैसे चाँद बिना रात नामुमकिन है\n.मेरी हर एक सांस अधूरी तुम बिन है\n',
    'englishLyrics':
        'Jaise Chand Bina Raat Namumkin Hai\nMeri Har Ek Saans Adhuri Tum Bin Hai (2)\nMein Fakeroon Sa Tere Dar Aata Hoon\nJis Jagha Dekhu Tujhi Ko Paata Hoon\nJaise Chand Bina Raat Namumkin Hai\nMeri Har Ek Saans Adhuri Tum Bin Hai\n\nTu Hi Bhakti Hai Meri Har Roz Mein Karlu\nNaam Ko Tere Prabhu Har Roz Mein Japlu\nTu Meri Manzil Tu Hi Manzil Ka Hai Zariya\nJo Bahe Aakhon Se Tu Wo Aankh Ka Dariya\n\nJaise Bin Aansoo Aankh Namumkim Hai\nMeri Har Ek Saans Adhuri Tum Bin Hai\nJaise Chand Bina Raat Namumkin Hai\nMeri Har Ek Saans Adhuri Tum Bin Hai\n\nKyun Tere Dar Ke Siva Kahin Aur Jau Mein\nTere Hi Aage Prabhu Ye Sar Jhukau Mein\nMein Musafir Hoon Bhatakta Tu Thikana Hai\nMein Hoon Chota Sa Seher Tu Toh Zamana Hai\n\nJaise Bhav Bina Darsh Namumkin Hai\n Meri Har Ek Saans Adhuri Tum Bin Hai\nJaise Chand Bina Raat Namumkin Hai\nMeri Har Ek Saans Adhuri Tum Bin Hai..\n',
    'originalSong': 'Dulhe Ka Sehra',
    'popularity': 0,
    'production': 'Bhakti Bhavna',
    'share': 0,
    'singer': 'Rishabh Sambhav Jain (RSJ)',
    'songNameEnglish': 'Jaise Chaand Bina',
    'songNameHindi': 'जैसे चाँद बिना',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/RxIakjG9ltk',
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
