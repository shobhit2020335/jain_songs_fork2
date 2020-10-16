import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Map<String, dynamic> currentSongMap = {
    'code': 'VA',
    'album': '',
    'aaa': 'valid | link',
    'genre': 'Stavan | Bhajan',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'व्हाला आदिनाथ!...\nमे तो पकड्यो तारो हाथ,\nमने देजो सदा साथ... ओ...\nव्हाला आदिनाथ ओ...(2)\nआव्यो तुम पास...\nलई मुक्तिनी एक आश,\nमने करशो ना निराश... ओ...\nव्हाला आदिनाथ ओ…\n\nतारा दर्शनथी मारा नयनो ठरे छे... नयनो ठरे छे,\nरोमे रोमे आ मारा पुलकित बने छे... पुलकित बने छे,\nभवोभवनो मारो उतरे छे थाक,\nहुं तो पामुं हळवाश, ओ ओ ओ ओ..\n व्हाला आदिनाथ ओ ओ ओ ओ...\n\nतारी वाणीथी मारूं मनडुं ठरे छे... मनडुं ठरे छे,\nकर्मवर्गणा मारी क्षण क्षण खरे छे...क्षण क्षण खरे छे,\nठरी जाय छे मारा कषायोनी आग,\nछूटे राग-द्वेषनी गांठ, ओ ओ ओ ओ...\nव्हाला आदिनाथ ओ ओ ओ ओ...\n\nतारा आज्ञाथी मारूं हैयुं ठरे छे... हैह्य ठरे छे,\nतुज पंथे आगळ वधवा सत्त्व मळे छे... सत्त्व मळे छे,\nटळी जाय छे मारो मोह अंधकार,\nखीले ज्ञान अजवाश, ओ ओ ओ ओ...\nव्हाला आदिनाथ ओ ओ ओ ओ...\n\nतारूं शासन पामीने आतम ठरे छे... आतम ठरे छे,\nमोक्ष मार्गमा ए तो स्थिर बने छे... स्थिर बने छे,\nमल्यो तारो मार्ग,\nमारा केवा सद्भाग्य, मारा केवा धन्यभाग, ओ ओ ओ ओ... व्हाला आदिनाथ ओ ओ ओ ओ...५\n\nव्हाला आदिनाथ!...\nमे तो पकड्यो तारो हाथ,\nमने देजो सदा साथ... ओ...\nव्हाला आदिनाथ ओ...(2)\nआव्यो तुम पास...\nलई मुक्तिनी एक आश,\nमने करशो ना निराश... ओ...\nव्हाला आदिनाथ ओ…\n',
    'originalSong': 'Unknown',
    'production': '',
    'share': 0,
    'singer': 'Bharti Ben Gada',
    'songNameEnglish': 'Vhala Adinath',
    'songNameHindi': 'व्हाला आदिनाथ',
    'tirthankar': 'Adinath',
    'youTubeLink': ''
  };
  AddSong currentSong = AddSong(currentSongMap: currentSongMap);
  await currentSong.addToFirestore();
  print('Added song successfully');

  // addSong currentSong = addSong(
  //   code: 'CMCR',
  //   album: '',
  //   aaa: 'Invalid',
  //   genre: 'Stavan | Bhajan',
  //   language: 'Gujarati',
  //   likes: 0,
  //   lyrics:
  //       'आणि मन शुद्ध आस्था,\nदेव जुहारु शाश्वता\nपार्श्वनाथ मन वांछित पुर\nचिंतामणि मारी चिंता चूर,\nशंखेश्वर दादा मारी चिंता चूर....(2)\n\nअणियाली थारी आँखड़ी\nजाणे कामलतणी पांखडी\nमुख दीठा दुःख जावे दूर\nचिंतामणि मारी चिंता चूर,\nशंखेश्वर दादा मारी चिंता चूर....(2)\n\nको केहने को केहने नमे ,\nमारा मन मा तुही गमे\nसदा जुहरु उगते सुर ....\nचिंतामणि मारी चिंता चूर,\nशंखेश्वर दादा मारी चिंता चूर....(2)\n\nबिछड़िया बालेसर बेल,\nवैरी दुश्मन पाछा भेल\nतू छे मारा हाज़रा हुज़ूर\nचिंतामणि मारी चिंता चूर,\nशंखेश्वर दादा मारी चिंता चूर....(2)\n\nयह स्तोत्र जो मनमें धरे\nतेहनो काज सदाई सरे\nआधी व्याधि सब जावे दूर\nचिंतामणि मारी चिंता चूर,\nशंखेश्वर दादा मारी चिंता चूर....(2)\n\nमुझ मन लागि तुमसु प्रीत\nदुझो कोई न आवे चित्त\nकर मुझ तेज प्रताप प्रचुर\nचिंतामणि मारी चिंता चूर,\nशंखेश्वर दादा मारी चिंता चूर....(2)\n\nभवो भव देजो तुम पद सेव\nश्री चिंतामणि अरिहंत देव\nसमय सुन्दर कहे गुण भरपूर\nचिंतामणि मारी चिंता चूर,\nशंखेश्वर दादा मारी चिंता चूर....(2)\n',
  //   originalSong: 'Unknown',
  //   production: 'Rajmundra Production',
  //   share: 0,
  //   singer: 'Mahesh Maru',
  //   songNameEnglish: 'Chintamani Mari Chinta Choor',
  //   songNameHindi: 'चिंतामणि मारी चिंता चूर',
  //   tirthankar: 'Parshwanath Swami',
  //   youTubeLink: '',
  // );
}

class AddSong {
  // String aaa;
  // String album;
  // String code;
  // String genre;
  // String language;
  // int likes;
  // String lyrics;
  // String originalSong;
  // String production;
  // int share;
  // String singer;
  // String songNameEnglish;
  // String songNameHindi;
  // String tirthankar;
  // String youTubeLink;
  Map<String, dynamic> currentSongMap;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  AddSong({this.currentSongMap});

  // addSong({
  //   this.aaa,
  //   this.album,
  //   this.code,
  //   this.genre,
  //   this.language,
  //   this.likes,
  //   this.lyrics,
  //   this.originalSong,
  //   this.production,
  //   this.share,
  //   this.singer,
  //   this.songNameEnglish,
  //   this.songNameHindi,
  //   this.tirthankar,
  //   this.youTubeLink,
  // });

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }
}
