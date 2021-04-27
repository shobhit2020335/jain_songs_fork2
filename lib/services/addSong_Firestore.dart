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
  currentSong.makestringSearchKeyword('SCPC',
      englishName:
          'Shri Chandraprabhu Chalisa Shri Chandra prabhu Chalisa Shri Chandraprabh Chalisa',
      hindiName: 'श्री चन्द्रप्रभु चालीसा श्री चन्द्र प्रभु चालीसा',
      originalSong: 'Shree Chandraprabhu Chalisa',
      album: 'jain chalisa',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'SCPC',
    'album': '',
    'aaa': 'valid',
    'category': 'Stotra',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'वीतराग सर्वज्ञ जिन, जिनवाणी को ध्याय |\nलिखने का साहस करूँ, चालीसा सिर-नाय ||१||\n\nदेहरे के श्री चंद्र को, पूजौं मन-वच-काय ||\nऋद्धि-सिद्धि मंगल करें, विघ्न दूर हो जाय ||२||\n\nजय श्री चंद्र दया के सागर, देहरेवाले ज्ञान-उजागर ||३||\nशांति-छवि मूरति अति-प्यारी, भेष-दिगम्बर धारा भारी ||४||\nनासा पर है दृष्टि तुम्हारी, मोहनी-मूरति कितनी प्यारी |५||\nदेवों के तुम देव कहावो, कष्ट भक्त के दूर हटावो ||६||\nसमंतभद्र मुनिवर ने ध्याया, पिंडी फटी दर्श तुम पाया ||७||\nतुम जग में सर्वज्ञ कहावो, अष्टम-तीर्थंकर कहलावो ||८||\nमहासेन के राजदुलारे, मात सुलक्षणा के हो प्यारे ||९||\nचंद्रपुरी नगरी अतिनामी, जन्म लिया चंद्र-प्रभ स्वामी ||१०||\nपौष-वदी-ग्यारस को जन्मे, नर-नारी हरषे तब मन में ||११||\nकाम-क्रोध-तृष्णा दु:खकारी, त्याग सुखद मुनिदीक्षा-धारी ||१२||\nफाल्गुन-वदी-सप्तमी भार्इ, केवलज्ञान हुआ सुखदार्इ ||१३||\nफिर सम्मेद-शिखर पर जाके, मोक्ष गये प्रभु आप वहाँ से ||१४||\nलोभ-मोह और छोड़ी माया, तुमने मान-कषाय नसाया ||१५||\nरागी नहीं नहीं तू द्वेषी, वीतराग तू हित-उपदेशी ||१६||\nपंचम-काल महा दु:खदार्इ, धर्म-कर्म भूले सब भार्इ ||१७||\nअलवर-प्रांत में नगर तिजारा, होय जहाँ पर दर्शन प्यारा ||१८||\nउत्तर-दिशि में देहरा-माँहीं, वहाँ आकर प्रभुता प्रगटार्इ ||१९||\nसावन सुदि दशमी शुभ नामी, प्रकट भये त्रिभुवन के स्वामी ||२०||\nचिहन चंद्र का लख नर-नारी, चंद्रप्रभ की मूरती मानी ||२१||\nमूर्ति आपकी अति-उजियाली, लगता हीरा भी है जाली ||२२||\nअतिशय चंद्रप्रभ का भारी, सुनकर आते यात्री भारी ||२३||\nफाल्गुन-सुदी-सप्तमी प्यारी, जुड़ता है मेला यहाँ भारी ||२४||\nकहलाने को तो शशिधर हो, तेज-पुंज रवि से बढ़कर हो ||२५||\nनाम तुम्हारा जग में साँचा, ध्यावत भागत भूत-पिशाचा ||२६||\nराक्षस-भूत-प्रेत सब भागें, तुम सुमिरत भय कभी न लागे ||२७||\nकीर्ति तुम्हारी है अतिभारी, गुण गाते नित नर और नारी ||२८||\nजिस पर होती कृपा तुम्हारी, संकट झट कटता है भारी ||२९||\nजो भी जैसी आश लगाता, पूरी उसे तुरत कर पाता ||३०||\nदु:खिया दर पर जो आते हैं, संकट सब खोकर जाते हैं ||३१||\nखुला सभी हित प्रभु-द्वार है, चमत्कार को नमस्कार है ||३२||\nअंधा भी यदि ध्यान लगावे, उसके नेत्र शीघ्र खुल जावें ||३३||\nबहरा भी सुनने लग जावे, पगले का पागलपन जावे ||३४||\nअखंड-ज्योति का घृत जो लगावे, संकट उसका सब कट जावे ||३५||\nचरणों की रज अति-सुखकारी, दु:ख-दरिद्र सब नाशनहारी ||३६||\nचालीसा जो मन से ध्यावे,पुत्र-पौत्र सब सम्पति पावे ||३७||\nपार करो दु:खियों की नैया, स्वामी तुम बिन नहीं खिवैया ||३८||\nप्रभु मैं तुम से कुछ नहिं चाहूँ, दर्श तिहारा निश-दिन पाऊँ ||३९||\n\nकरूँ वंदना आपकी, श्री चंद्रप्रभ जिनराज |\nजंगल में मंगल कियो, रखो ‘सुरेश’ की लाज ||४०||\n',
    'englishLyrics': '',
    'originalSong': '',
    'popularity': 0,
    'production': 'Yuki Cassettes',
    'share': 0,
    'singer': 'Rajendra Jain',
    'songNameEnglish': 'Shri Chandraprabhu Chalisa',
    'songNameHindi': 'श्री चन्द्रप्रभु चालीसा',
    'tirthankar': 'Chandraprabhu Swami',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/SWd0mCml6vA',
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
