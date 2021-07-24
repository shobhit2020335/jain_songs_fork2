import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/oneSignal_notification.dart';
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
  currentSong.extraSearchKeywords('AACHA',
      englishName: 'chaturymas chaturyamas',
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
    'code': 'AACHA',
    'album': 'Chaturmas Pravesh',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Chaturmas',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'आओजी आओ, गुरु आओजी आq      0P;ZZZZZओ, मेरे आंगन आओ\nगाओरे गाओ, सब मिलकर गाओ,गुरु गुण आज गाओना\nआयो आयो चातुर्मास है आयो\nगुरुवर के आने से मन हरख्यो-2\nमेरे भाग्य खिले है , गुरु तुम सम मिले है\nआज खुशिया है छाई , ज्ञान की गंगा आयी\nमोर पपीहा कोयल सांझ सुनायो\n\nजैसे बारिश की रिमझिम बरसने लगी\nऐसे गुरुवर की वाणी भी झरने लगी\nपतझड़ में बसंत , गुरु का आगमन ,\nहर आंगन घर आंगन सजायेंगे हम\nपुण्य प्रबल से अक्सर द्वार पे आयो,\nगुरुवर के आने से मन हरखायो\n\nजबसे आयी खबर , गुरु आएंगे घर,\nहम खड़े बेकरार , कर रहे इंतज़ार\nबादलो से भी संगीत बजाया गया,\nजब तप का नाद सजाया गया,\nढोल नगाड़े शहनाई बजाओ\n\nआयो आयो चातुर्मास है आयो\nगुरुवर के आने से मन हरख्यो-2\nमेरे भाग्य खिले है , गुरु तुम सम मिले है\nआज खुशिया है छाई , ज्ञान की गंगा आयी\nमोर पपीहा कोयल सांझ सुनाय\n',
    'englishLyrics':
        'Aojee Ao , Guru Aojee Ao, Mere Angana Ao\nGaaore Gaao, Saba Milakara Gaao,guru Guna Aja Gaaonaa\nAyo Ayo Chaturmas Hai Ayo\nGuruvar Ke Ane Se Mana Harakhyo-2\nMere Bhaagya Khile Hai , Guru Tuma Sama Mile Hai\nAja Khushiyaa Hai Chhaai , Gnaana Kee Gangaa Ayee\nMora Papeehaa Koyala Saanza Sunaayo\n\nJaise Baarisha Kee Rimazima Barasane Lagee\nAise Guruvara Kee Vaanee Bhee Zarane Lagee\nPatazad Men Basanta , Guru Kaa Agamana ,\nHara Angana Ghara Angana Sajaayenge Hama\nPunya Prabala Se Aksara Dvaara Pe Ayo ,\nGuruvar Ke Ane Se Mana Harakhaayo\n\nHama Khade Bekaraara , Kara Rahe Intadaara\nBaadalo Se Bhee Sangeeta Bajaayaa Gayaa ,\nJaba Tapa Kaa Naada Sajaayaa Gayaa,\nDhola Nagaade Shahanaai Bajaao\n\nAyo Ayo Chaturmas Hai Ayo\nGuruvar Ke Ane Se Mana Harakhyo-2\nMere Bhaagya Khile Hai , Guru Tuma Sama Mile Hai\nAja Khushiyaa Hai Chhaai , Gnaana Kee Gangaa Ayee\nMora Papeehaa Koyala Saanza Sunaayo\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Viya Music India',
    'share': 0,
    'singer': 'Anish Rathod',
    'songNameEnglish': 'Aayo Aayo Chaturmas Hai Aayo',
    'songNameHindi': 'आयो आयो चातुर्मास है आयो',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/QxJAFMpYucE',
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
