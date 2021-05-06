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
  currentSong.makestringSearchKeyword('MB',
      englishName: 'मेरी भावना ',
      hindiName: 'Meri Bhavna mere',
      originalSong: 'Asli Naqli Tera Mera Pyar Amar Lata Mangeshkar',
      album: 'Vicky D Parekh',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'MB',
    'album': 'Jinwani Sangrah',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'जिसने राग - द्वेष - कामादिक जीते , सब जग जान लिया |\nसब जीवो को मोक्ष मार्ग का , निस्पृह हो उपदेश दिया ||\nबुध्ध - वीर - जिन - हरि - हर - ब्रम्हा , या उसको स्वाधीन कहो |\nभक्ति - भाव से प्रेरित हो यह , चित्त उसी में लीन रहो ||१||\n\nविषयो की आशा नहि जिनके , साम्य भाव धन रखते हैं |\nनिज पर के हित - साधन में जो , निश दिन तत्पर रहते हैं ||\nस्वार्थ त्याग की कठिन तपस्या , बिना खेद जो करते हैं |\nऐसे ज्ञानी साधू जगत के , दुःख समूह को हारते हैं ||२||\n\nरहे सदा सत्संग उन्ही का , ध्यान उन्ही का नित्य रहे हैं |\nउन्ही जैसी चर्या में यह , चित्त सदा अनुरक्त रहे हैं ||\nनहीं सताऊ किसी जीव को , झूठ कभी नहीं कहा करू |\nपर - धन - वनिता पर न लुभाऊ , संतोशामृत पीया करू ||३||\n\nअहंकार का भाव न रखु , नहीं किसी पर क्रोध करू |\nदेख दुसरो की बढती को , कभी न इर्ष्या भाव धरु ||\nरहे भावना ऐसी मेरी , सरल सत्य व्यव्हार करू |\nबने जहा तक जीवन में , औरो का उपकार करू ||४||\n\nमैत्री भाव जगत में मेरा , सब जीवो से नित्य रहे |\nदींन - दुखी जीवो पर मेरे , उर से करुना - स्रोत बहे ||\nदुर्जन - क्रूर - कुमार्ग - रतो पर , क्षोभ नहीं मुझको आवे |\nसाम्यभाव रखु में उन पर , ऐसी परिणति हो जावे ||५||\n\nगुनी जनों को देख ह्रदय , में मेरे प्रेम उमड़ आवे |\nबने जहाँ तक उनकी सेवा , करके यह मन सुख पावे ||\nहोऊ नहीं क्रुत्ग्न कभी में , द्रोह न मेरे उर आवे |\nगुण ग्रहण का भाव रहे , नित दृस्थी न दोषों पर जावे ||६||\n\nकोई बुरा कहो या अच्छा , लक्ष्मी आवे या जावे |\nअनेक वर्षो तक जीउ या , मृत्यु आज ही आ जावे ||\nअथवा कोई ऐसा ही भय , या लालच देने आवे |\nतो भी न्याय मार्ग से मेरा , कभी न पद डिगने पावे ||७||\n\nहोकर सुख में मग्न न दुले दुःख में कभी न घबरावे |\nपर्वत नदी श्मशान भयानक अटवी से नहीं भय खावे ||\nरहे अडोल अकंप निरंतर यह मन दृद्तर बन जावे |\nइस्ट वियोग अनिस्ठ योग में सहन - शीलता दिखलावे ||८||\n\nसुखी रहे सब जीव जगत , के कोई कभी न घबरावे |\nबैर पाप अभिमान छोड़ जग , नित्य नए मंगल गावे ||\nघर घर चर्चा रहे धर्मं की , दुष्कृत दुस्खर हो जावे |\nज्ञान चरित उन्नत कर अपना , मनुज जन्म फल सब पावे ||९||\n\nइति भीती व्यापे नहीं जग में , वृस्ती समय पर हुआ करे |\nधर्मनिस्ट होकर राजा भी न्याय , प्रजा का किया करे ||\nरोग मरी दुर्भिक्स न फैले , प्रजा शांति से जिया करे |\nपरम अहिंसा धर्म जगत में , फ़ैल सर्व हित किया करे ||१०||\n\nफैले प्रेम परस्पर जगत में , मोह दूर हो राह करे |\nअप्रिय कटुक कठोर शब्द नहीं , कोई मुख से कहा करे ||\nबनकर सब “युगवीर” ह्रदय , से देशोंनती रत रहा करें |\nवस्तु स्वरुप विचार खुशी , से सब संकट सहा करे ||११||\n',
    'englishLyrics': '',
    'originalSong': '',
    'popularity': 0,
    'production': 'Yuki Music',
    'share': 0,
    'singer': 'Ravindra Jain',
    'songNameEnglish': 'Meri Bhavna',
    'songNameHindi': 'मेरी भावना',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/75WzV_lL3Mw',
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
