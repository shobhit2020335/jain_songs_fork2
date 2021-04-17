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
  currentSong.makestringSearchKeyword('HCTTCA',
      englishName: 'Hu Chu Tamara Tame Cho Amara hu chu tamaro tame cho amara',
      hindiName: 'हुं छुं तमारों तमे छो मारा',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'HCTTCA',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'धर्मना दायक तमे धुरंधर, तमे परम तारक शुभंकर\nतमे कृपानो सरस सागर, तमने आपु अनंत आदर, \nसाहेब...साहेब...साहेब........\n\nतमे तो मुजने बधु ज आप्यु मैं तो तमोने कोई न आप्यु\nतमें छो मारा जीवन दाता, तमें ज पिता तमे ज माता\nहुं छुं तमारो, तमे छो मारा, आ वात तमने, कही दऊ छूं..\n\nतमारी पासे ज बेसवु छे, तमारी छायामां मां बसवु छे\nतमारी भक्ति थी खुशी मळे छे, तमारो शक्तिथी दुःख टळे छ\nहं छु नमारो, नमे छो अमारा, आ वात तमने, कही दऊ छु...\n\nयाद करू छु हर पळे, मनमा धरु छु हर पळे\nजे तमारा मां मळे, तेवु बीजामा ना मळे\nसाहेब मारा प्राण तमे छो. साहेब मारु ध्यान तमे छो\nसोथी सलामत स्थान तमे छो, आतम तत्व नु जान तमे छो\nहुं छुं तमारो, तमे छो अमारा, आ वात तमने, कही दऊ छुं..\n\nहूं तमारा संगमा, दीनरात रहेवा चाहुं छु\nमारा मननी वान बधी, तमने ज कहेवा चाहुं छु\nतमारा दरबारनी, देवधि ने जोया करूं\nक्यारे मळशे परमपद औ, चिंता थी रोया कर\nतमारी पासे ज बसवु छे. तमारी छायामां बस छ\nतमारी भक्तिधी खुशी मळे छे, तमारी शक्तिथी दुःख टळे छे\nहुं छुं तमारों, तमे छो मारा, आ बात तमने, कहीं दऊ छु..\n\nसौथी मोटुं बळ तमे  ने, सोथी पावन पळ तमे\nसौथी ऊंचु मंगळ तमे नै, नंदप्रभा जळहळ तमें\nसाचुं तीरथ स्थळ नमे ,मुज पुण्यनु शुभ फळ तमै\nआनंदमां अविचल नमे ने, जळ झाकळ ने कमळ नमे....\nहुं छुं तमारों, तमे छो मारा, आ बात तमने, कहीं दऊ छु.. (2)\n',
    'englishLyrics':
        'Dharma na dayak tame dhurandhar\nTame param tarak shubhankar\nTame krupa nu saras saagar\nTamane aapu anant aadar\nSaheb......(4)\n\nTame to mujne badhuj aapyu\nMe to tamone kai na aapyu\nTame cho mara jeevan daata\nTamej pita tamej mata\nHu chu tamaro,tame cho mara...(2)\nAa vaat tamane kai dau chu\n\nTamari pasej besavu che\nTamari chaya ma vasavu che...(2)\nTamari bhakti thi khushi made che\nTamati shakti thi dukh tade che\nHu chu tamaro,tame cho mara\nAa vaat tamane kai dau chu\n\nYaad karu chu har pade\nMan ma dharu chu har pade\nJe tamara ma made\nEvu bija ma na made\nSaheb mara praan tame cho\nSaheb maru dhyaan tame cho\nSaheb mara praan tame cho\nSaheb maru dhyaan tame cho\nSahu thi salamat sthaan tame cho\nAatam tatva nu gyaan tame cho\nHu chu tamaro,tame cho mara\nAa vaat tamane kai dau chu\n\nHu tamara sang ma\nDin raat rehava chahu chu\nMara mann ni vaat badhi\nTamanej kehava chahu chu\nTamara darabar ni\nDevardhi ne joya karu\nKyare madshe param pad\nA chinta thi roya karu\nHu chu tamaro,tame cho mara...(2)\n\nSau thi motu bad tame re\nSauthi pawan pad tane\nSauthi uchu mangal tame re\nKshatriya kund jadhad tame\nSachu tirth sthad tame\nMuj punya nu shubh fad tame\nAanand ma avichal tane\nJad jaakad ne a kamad tame\nHu chu tamaro,tame cho mara...(2)\nAa vaat tamane kai dau chu\nHu chu tamaro,tame cho mara...(2)\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jin Stavan',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'hu chu tamaro',
    'songNameHindi': 'हुं छुं तमारों',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/Ro-eq7obIMc',
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
