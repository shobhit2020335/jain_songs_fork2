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
  currentSong.extraSearchKeywords('DSMH',
      englishName: '',
      hindiName: '',
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
    'code': 'DSMH',
    'album': '',
    'aaa': 'valid',
    'category': 'Bhakti',
    'genre': '',
    'gujaratiLyrics':
        'દીવડો ધરો રે પ્રભુ દીવડો ધરો,\nમારા તન મન કેરાં તિમિર હરો\nદીવડો ધરો…\n\nમાયાનગરનાં રંગરાગમાં,\nકાયા આ રંગાણી રે (૨)\nભવસાગરમાં ભમતાં ભમતાં,\nપીધા ખારા પાણી રે (૨)\nદુઃખડા સર્વે દૂર કરો… દીવડો\n\nજાણી જોઈને મારગ વચ્ચે,\nમેં તો વેર્યા કાંટા (૨)\nઅખંડ વહેતી પ્રેમ નદીના,\nપાડ્યા હજારો ફાંટા (૨)\nદેખાડો પ્રભુ રાહ ખરો… દીવડો\n\nસ્વાર્થ તણી આ દુનિયા માંહે,\nઆશા એક તમારી રે (૨)\nજીવનના સંગ્રામમાં જો જો,\nજાઉં ના હું હારી રે, (૨)\nહૈયે, ભક્તિભાવ ધરો,\nહૈયે મારા વાસ કરો\nઅંતરાયો સર્વે દૂર કરો… દીવડો\n',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'दीवडो धरो रे प्रभु दीवडो धरो,\nमारा तन मन केरां तिमिर हरो\nदीवडो धरो…\n\nमायानगरनां रंगरागमां,\nकाया आ रंगाणी रे (२)\nभवसागरमां भमतां भमतां,\nपीधा खारा पाणी रे (२)\nदुःखडा सर्वे दूर करो… दीवडो\n\nजाणी जोईने मारग वच्चे,\nमें तो वेर्या कांटा (२)\nअखंड वहेती प्रेम नदीना,\nपाड्या हजारो फांटा (२)\nदेखाडो प्रभु राह खरो… दीवडो (२)\n\nस्वार्थ तणी आ दुनिया मांहे,\nआशा एक तमारी रे (२)\nजीवनना संग्राममां जो जो,\nजाउं ना हुं हारी रे, (२)\nहैये, भक्तिभाव धरो,\nहैये मारा वास करो\nअंतरायो सर्वे दूर करो… दीवडो (३)\n',
    'englishLyrics': '',
    'originalSong': '',
    'popularity': 0,
    'production': 'Sourabh Kadawat',
    'share': 0,
    'singer': 'Sourabh Kadawat',
    'songNameEnglish': 'Divdo Dharo Re Prabhu',
    'songNameHindi': 'दिवड़ो धरो रे प्रभु',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/_LWRQVBTyFc',
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
