import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('BY',
      englishName: '',
      hindiName: 'Muni Shri 108 Praman Sagar Ji',
      originalSong: '',
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
    'code': 'BY',
    'album': '',
    'aaa': 'valid',
    'category': 'Stotra',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'मन को प्रसन्न रखें पूरा शरीर ढीला छोड़ दें\nॐ की ध्वनि लंबी सांस अंदर से बाहर की ओर छोड़ते हुए 3 बार ॐ बोले।\nमुंह बंद करके अनुगूंज की स्थिति में ॐ की ध्वनि 3 बार करें। अनुमोद\nहे प्रभु आपके चरणो में कोटि कोटि नमन ,कोटि कोटि वंदन, कोटि-कोटि आभार। (तीन बार)\nहे प्रभु आपकी कृपा से मुझे जीवन का यह नया दिन मिला।\nहे प्रभु मुझे ऐसी शक्ति दे कि आज के इस दिन को अच्छा दिन बना सकूं।\nहे प्रभु सब का दिन अच्छा हो मेरा दिन अच्छा हो ।आज का दिन सबका अच्छा दिन बने। (यह तीन बार बोलें)\nसबकी रक्षा हो ,सभी निरामय हों , सब जन निर्भय हो। निर्भयोSहं।\nहे प्रभु सबका मंगल, हो सब जग का मंगल हो,सब जन का मंगल हो।\nहे प्रभु सबकी रक्षा हो , सभी निर्भय हो, सभी निरामय हो , नि२भेोsहं ।\nसर्वत्र शांति हो,सब में शांति हो, जग में शांति हो।\nहे प्रभु सभी स्वस्थ रहें।\nहे प्रभु सभी खुश रहें ,सभी स्वस्थ रहें ,सब में शांति हो ,सभी सुरक्षित रहें ,सबकी रक्षा हो , सब जग निर्भय हो, जग में शांति हो,जग का मंगल हो, सभी निरोगी हो, सभी पसन्न रहे, सबका मंगल हो। (9 बार पढ़े)\nहे प्रभु मैं अपनी सभी बुरी स्मृतियों का परित्याग करता हूं\nहे प्रभु बीते दिन में मैंने जो कुछ भी में से बुरा सोचा हो,बुरा बोला हो अथवा जो भी बुरा कहा हो उसका मुझे घोर पश्चाताप है। मैं उसकी निंदा करता हूं, आलोचना करता हूं और उसका परित्याग करता हूं।\nहे प्रभु मेरे द्वारा बुरा बोलने में ,बुरा सोचने में, बुरा कहने में जिस किसी को कष्ट पहुंचा हो तो मैं उनसे क्षमा मागता हूं, मै सभी को क्षमा करता हूं । वे भी मुझे क्षमा करें,में अपने मन की गाठे खोलता हूं। सभी मेरे मित्र है, मेरा मन पवित्र है।\nहे प्रभु मेरे दुष्कृत्यों के कारण प्रकृति में जिस किसी को किसी भी प्रकार का कष्ट पहुंचा हो ,उनसे मैं क्षमा मांगता हूं और वे भी मुझे क्षमा करें ।\nसभी से मेरी मैत्री है, सभी की मुझसे मेत्री है।\nसबसे मेरा प्रेम है, सभी का मुझसे प्रेम है, में प्रेम पूर्ण हूं।\nसभी मेरे मित्र हैं ,मेरा मन पवित्र है, मैं पवित्र आत्मा हूं ,पवित्रोSहं।\nस्वस्थोsहं मेरा अंग अंग स्वस्थ और सरल है, ।\nसबलोsहं, मेरा अंग अंग सबल है\nशांतोsहं मै शांत हूं।\nहे प्रभु मै पवित्र मन से विश्व की समस्त सकारात्मक शक्तियां और स्मृतियों का पवित्र ह्रदय से आव्हान करता हूं ।\nहे प्रभु विश्व की समस्त सकारात्मक शक्तियां घनीभूत होकर मेरे भीतर प्रवेश करें।\nहे प्रभु ऊर्जा की यह समस्त सकारात्मक उर्जा (धार )मेरे मस्तिष्क में बादल (नीली धारा) की तरह प्रवाहित हो रही है मै इसे महसूस कर रहा हूं ये ऊर्जा की अविरल धार प्रवाह होकर गर्दन ,कंधों, ह्रदय ,पैर ,पीठ ,छाती , हाथ , पैर,कमर ,फेफड़े एवं समस्त अंगो में एक साथ ऊर्जा एक-एक अंग में प्रवाहित हो रही है, हमारे शरीर में प्रवेश होकर हमारा शरीर ब्रम्हांड की सारी शक्तियों और ऊर्जा का पिंड बन गया है ।, अपने अंदर इस ऊर्जा को समाहित करें।हमारा समस्त शरीर शक्तिमान और ऊर्जावान हो गया है।(शरीर के जिस अंग में जहां भी दर्द हो या कोई तकलीफ़ है उस हिस्से में लाल रंग महसूस करे। मेरा huminity पावर मजबूत हो गया 72 हजार धमनियों में ऊर्जा भर गई, मेरे शरीर का पूरा दर्द चला गया है।महसूस करें। मेरा मन शांत हो” सभी शांत हो . सर्वत्र संतुष्टि हो।\nमै ऊर्जावंत हूं,ऊर्जावंतोSहं मै ऊर्जावान हूं,।\nशक्तिसंपन्ननाेsहं में शक्ति संपन्न हूं,मुझ में शक्ति है।\nस्वस्थोSहं ,मैं स्वस्थ हूं ।\nसुरक्षिततोsहं,मैं सुरक्षित हूं।\nअभयोगSहं, में अभय हूं।\nप्रसन्नोsहं,में प्रसन्न हूं।\n मैं स्वस्थ हूं ,मेरा परिवार स्वास्थ्य है।\nमैं सुरक्षित हूं, मेरा परिवार सुरक्षित है । सभी सुरक्षित है।\nमैं संतुष्ट हूं, संतुष्टोsधहं सर्वत्र संतुष्टि हो।\nपरिपूर्णोSहं मै पूर्ण हूं ।\nमैं समर्थ हूं, समरथोsहं।\nमैं पवित्र आत्मा हूं पवित्रोSहं।\nमेरा मन पवित्र है मैं बैर रहित हूं, दोष रहित, राग रहित हूं। मै अपनी पवित्रता से सभी सकारात्मक शक्तियां को अपने अंदर महसूस कर रहा हूं।\nमैं शुद्ध आत्मा हूं , शुद्धोSहं ।\nसहजोSहं मै सहज हूं।\nमैं शांत हूं , शांतोsहं।\nमै चेतन आत्मा हूं, चेतन्योSहं\nसोSहं।( जितना बार बोलना हो)\nन कोई चर्चा, सब शांत, न कोई चिंता, न कोई भय,न कोई चेष्ठा। मेरे भीतर विराजमान शुद्ध आत्मा मैं हूं, मै शुद्ध पवित्र परमात्मा हूं।\n\nमंगल भावना\n मंगल - मंगल होय जगत् में, सब मंगलमय होय ।\nइस धरती के हर प्राणी का, मन मंगलमय होय ।।\n\nकहीं क्लेश का लेश रहे ना, दु:ख कहीं भी होय।\nमुन में चिन्ता भय न सतावे, रोग-शोक नहीं होय।।\nनहीं बैर अभिमान हो मन में, क्षोभ कभी नहीं होय ।\nमैत्री प्रेम का भाव रहे नित मन मंगलमय होय ||१||\nमंगल - मंगल ......\n\nमन का सब संताप मिटे अरू, अन्तर उज्ज्वल होय।\nरागद्वेष औ मोह मिट जावे, आतम् निर्मल होय।।\nप्रभु का मंगल गान करें सब, पापों का क्षय होय।\nइस जग के हर प्राणी का हर दिन, मंगलमय होय ||१||\nमंगल - मंगल ......\n\nगुरु हो मंगल, प्रभु हो मंगल, धर्म सुमंगल होय।\nमात-पिता का जीवन मंगल, परिजन मंगल होय।।\nजन का मंगल, गण का मंगल, मन का मंगल होय।\nराजा-प्रजा सभी का मंगल, धरा धर्ममय होय ||3||\nमंगल - मंगल ......\n\nमंगलमय हो प्रात हमारा, रात सुमंगल होय।\nजीवन के हर पल हर क्षण की बात सुमंगल होय।।\nघर-घर में मंगल छा जावे, जन-जन मंगल होय।\nइस धरती का कण-कण पावन औ मंगलमय होय ||४||\nमंगल - मंगल ......\n\nदोहा\nसब जग में मंगल बढे, टले अमंगल भाव ।\nहै प्रमाण की भावना सबमें हो सद्-भाव ||\n',
    'englishLyrics': '',
    'originalSong': '',
    'popularity': 0,
    'production': 'Muni Shri 108 Praman Sagar Ji',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Bhavna Yog',
    'songNameHindi': 'भावना योग',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/7ljjnQJOb8o',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  String searchKeywords = '';

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
    searchKeywords = searchKeywords.toLowerCase() + englishName + hindiName;
    searchKeywords = searchKeywords +
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
