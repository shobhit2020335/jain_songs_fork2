import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore();
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.makestringSearchKeyword('PAP',
      englishName: 'Parva Aaya Paryushan',
      hindiName: 'पर्व आया पर्युषण',
      originalSong: 'O Maahi Ve',
      album: 'Kesari',
      tirthankar: 'Arijit Singh',
      extra1: '',
      extra2: '',
      extra3: '');
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'PAP',
    'album': 'Kesari',
    'aaa': 'valid',
    'genre': 'Paryushan | Latest | Stavan',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'हो.. आया रे..\nपर्व आया पर्युषण,\nके जैनियों का पर्व सुहाना,\nमहिमा बड़ी है महान,\nके पर्व है ये सदियों पुराना।\nये है पर्वा धिराज,\nपर्वो का सिरताज,\nजैनियों की शान,\nजिसपे सबको है नाज\nसब.. के.. दिल... में उमंग,\nपलके बिछाकर के,\nसजाये देखो घर और अंगना,\nमहिमा बड़ी है महान,\nके जैनियों का पर्व सुहाना।।\n\nमंदिर ये सज गये जिनवर के,\nउपाश्रय में पड़े चरण गुरुवर के,\nआठ दिनों के ये, पल है सुहाने,\nभक्ति की मस्ती में, सब है दीवाने,\nक्षमादान का ये पर्व,\nजिसपे हमको है गर्व,\nदिलबर दिल से मनाना,\nपर्युषण महापर्व,\nबीत ना जाये ये पल,\nप्राची गाये दिल से भजन,\nकी भक्तो को भक्ति में झूमना।\nमहिमा बड़ी है महान,\nके पर्व है ये सदियों पुराना।\n\nहो.. आया रे..\nपर्व आया पर्युषण,\nके जैनियों का पर्व सुहाना,\nमहिमा बड़ी है महान,\nके पर्व है ये सदियों पुराना।\nये है पर्वा धिराज,\nपर्वो का सिरताज,\nजैनियों की शान,\nजिसपे सबको है नाज\nसब.. के.. दिल... में उमंग,\nपलके बिछाकर के,\nसजाये देखो घर और अंगना,\nमहिमा बड़ी है महान,\nके जैनियों का पर्व सुहाना।।',
    'originalSong': 'O Maahi Ve | Arijit Singh',
    'popularity': 0,
    'production': '',
    'share': 0,
    'singer': 'Prachi Jain',
    'songNameEnglish': 'Parva Aaya Paryushan',
    'songNameHindi': 'पर्व आया पर्युषण',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/vMXD6QCgTMw'
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void makestringSearchKeyword(
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
    String currentString;
    currentString = englishName.toLowerCase() + ' | ' + hindiName.toLowerCase();
    currentString = currentString +
        ' | ' +
        tirthankar.toLowerCase() +
        ' | ' +
        originalSong.toLowerCase() +
        ' | ' +
        album.toLowerCase() +
        ' | ' +
        extra1.toLowerCase() +
        ' | ' +
        extra2.toLowerCase() +
        ' | ' +
        extra3.toLowerCase();
    _addSearchKeywords(code, currentString);
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
