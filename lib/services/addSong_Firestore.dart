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
  currentSong.extraSearchKeywords('CAR',
      englishName: 'chaturyamas chaturymas',
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
    'code': 'CAR',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Chaturmas',
    'gujaratiLyrics': '',
    'language': 'Marwadi',
    'likes': 0,
    'lyrics':
        'आयो रे , आयो रे , चातुर्मास आयो रे\nआयो रे आयो चातुर्मास है आयो,छायो रे छायो मंगल अवसर -2\nमन गायो छायो , रंग अनोखा धरती गगन पर छायो\nमन ये हरखायो , गुरु गुण गायो\nआयो रे आयो...\n\nगुरु भक्ति के सारे मोती , मनका सिप जमायो,\nपूण्य प्रभा ये पूण्य ये बेला , पावन चरणें आयो,\nदेखो , आये गुरु द्वार मारे\nआये आये सुख बरसाए , आये रे\nआये आये सुख बरसाए आंगन आये रे,\nमेरा जीवन एक सागर , गुरु मेरी पतवार होवे,\nपूज्य गुरुवर कृपा करदो , मन ये मेरा पावन होवे\nआयो चातुर्मास....\n\nमंगल चरणें पावन चरणें , चातुर्मास ये आया,\nगुरु शरण मे आये प्राणी , मन है ये हर्षाया,\nगुरु का सहारा जीवन का किनारा\nगुरु वाणी अमृत ऐसो पायो पायो पायो\n\nगुरुवर मेरे पारब्रह्म है , वो ही मेरे भगवान\nजीवन पथ पे देते सहारा, वो मेरा विमान,\nगुरु गुण गाऊ, भाव मै जगाऊ\nचातुर्मास आया आया भक्ति सरगम लाया\nआयो रे....\n',
    'englishLyrics':
        'Aayo Re , Aayo Re , Chaturmas Aayo Re\nAayo Re Aayo Chaturmas Hai Aayo,chaayo Re Chaayo Mangala\nAvasara -2\nMann Gaayo Chaayo , Ranga Anokhaa Dharatee Gagana Para Chaayo\nMann Ye Harakhaayo , Guru Gun Gaayo\nAayo Re Aayo...\n\nGuru Bhakti Ke Saare Motee , Mannkaa Sipa Jamaayo,\nPunya Prabhaa Ye Punya Ye Belaa , Paavana Charanen Aayo,\nDekho , Aaye Guru Dvaara Maare\nAaye Aaye Sukha Barasaae , Aaye Re\nAaye Aaye Sukha Barasaae Aangana Aaye Re,\nMeraa Jeevana Eka Saagara , Guru Meree Patavaara Hove,\nPujya Guruvara Krupaa Karado , Mann Ye Meraa Paavana Hove\nAayo Chaaturmaasa....\n\nMangala Charanen Paavana Charanen , Chaturmas Ye Aayaa,\nGuru Sharana Me Aaye Praanee , Mann Hai Ye Harshaayaa,\nGuru Kaa Sahaaraa Jeevana Kaa Kinaaraa\nGuru Vaanee Amruta Aiso Paayo Paayo Paayo\n\nGuruvara Mere paarabrahma hai, vo hee mere bhagavaana,\nJeevana patha pe dete sahaara, vo meraa vimaana,\nGuru Guna Gaau, Bhaava Mai Jagaau\nChaturmas Aayaa Aayaa Bhakti Saragama Laayaa\nAayo Re....\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jainguruganesh',
    'share': 0,
    'singer': 'Darshit A Gadiya',
    'songNameEnglish': 'Chaturmas Hai Aaya',
    'songNameHindi': 'चातुर्मास आयो रे',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/b768DT2qklQ',
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
