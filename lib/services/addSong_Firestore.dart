import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.makestringSearchKeyword('CPMG',
      englishName: 'Chowk purao mangal gao',
      hindiName: 'चोख पुरावो माटी रंगावो',
      originalSong: 'Chok purao mangal gao',
      album: 'Kailash Kher',
      tirthankar: '',
      extra1: 'आज मेरे प्रभु घर आवेंगे',
      extra2: 'Aaj mere prabhu ghar aavenge',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'CPMG',
    'album': '',
    'aaa': 'valid',
    'genre': 'Stavan',
    'language': 'Marwadi',
    'likes': 0,
    'lyrics':
        'Chowk purao mangal gao\nAaj mere prabhu ghar aavenge...\nAangi rachavo mughat chadavo...(2)\nAaj mere prabhu mann bhaye hai ...(2)\nAaj mere prabhu ghar aavenge...\n\nAeri sakhi mangal gavo reh...\nDharti ambar sajavo reh...\nUtarege aaj mere\nPrabhu ki savari... (2)\nHar koi nacho gaavo re...\nDhol manjira bajavo reh...(2)\nAaj prabhuji mere mann padhare hai...\nAaj jinji mere mann padhare hai…\nKhabar sunavujo khusi reh jatavujo...(2)\nAaj mere prabhu ghar aavenge...\n\nRim jhim badal barase\nKali kali phul khile...(2)\nKhusiya ne aaj mere daale hain dera..(2)\nGannnnanan gant baje...Prabhu naam shank rateh...\nAangan aangan hai khusiyo ka mela...(2)\nAnhad naad bajavo ori sab mil...(2)\nAaj mere prabhu ghar aavenge...\n\nChowk purao mangal gao\nAaj mere prabhu ghar aavenge...\n',
    'englishLyrics':
        '(Not Accurate)\nचोख पुरावो, माटी रंगावो,\nआज मेरे प्रभु घर आवेंगे,\n\nखबर सुनाऊ जो, ख़ुशी ये बताओ जो,\nआज मेरे प्रभु घर आवेंगे।।\n\nहेरी सखी मंगल गावो री,\nधरती अम्बर सजाओ री,\nउतरेगी आज मेरे प्रभु की सवारी,\nहेरी कोई काजल लाओ रे,\nमोहे काला टीका लगाओ री,\nउनकी छब से दिखु में तो प्यारी,\nलक्ष्मी जी वारो ,\nनजर उतारो,\nआज मेरे प्रभु घर आवेंगे।।\n\nरंगो से रंग मिले,\nनए नए ढंग खिले,\nख़ुशी आज द्वारे मेरे डाले है डेरा,\nपीहू पीहू पपीहा रटे,\nकुहू कुहू कोयल जपे,\nआँगन आँगन है परियो ने घेरा,\nअनहद नाद बजाओ रे सब-मिल,\nआज मेरे प्रभु घर आवेंगे।।\n\nचोख पुरावो, माटी रंगावो,\nआज मेरे प्रभु घर आवेंगे,\nआज मेरे प्रभु घर आवेंगे।।\n',
    'originalSong': 'Piya Ghar Aavenge | Kailash Kher',
    'popularity': 0,
    'production': 'Jain Stavan Official',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Chowk purao (Aaj Mere Prabhu Ghar Aavenge)',
    'songNameHindi': 'चोख पुरावो (आज मेरे प्रभु घर आवेंगे)',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/jE8J4C3HxQ0'
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
    currentString = englishName.toLowerCase() + ' ' + hindiName.toLowerCase();
    currentString = currentString +
        ' ' +
        tirthankar.toLowerCase() +
        ' ' +
        originalSong.toLowerCase() +
        ' ' +
        album.toLowerCase() +
        ' ' +
        extra1.toLowerCase() +
        ' ' +
        extra2.toLowerCase() +
        ' ' +
        extra3.toLowerCase();
    _addSearchKeywords(code, currentString);
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
