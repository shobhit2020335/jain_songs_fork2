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
  currentSong.extraSearchKeywords('PNKP',
      englishName: 'O devadhi deva',
      hindiName: 'ओ देवाधिदेवा',
      originalSong: 'Varsitap parna',
      album: 'પારણિયાને કાજ પધારો ઓ દેવાધિદેવા',
      tirthankar: 'gujrati',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् mahavir jayanti स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'PNKP',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Tapasya',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'पारणियाने काज पधारो… ओ देवाधिदेवा…\nपारणियाने काज पधारो… ओ देवाधिदेवा…\nविनवे झूरे झंखे लोको… प्रभु! स्वीकारो सेवा…\nपारणियाने…\n\nदिवसे झंखे राते झूरे तन-मन-धन ने देता,\nऋषभ प्रभु लेता नथी कांई एकबीजाने के’ता,\nनथी समजाता राजा अमारा.. भाग्य रूठ्या छे एवा\nओ देवाधिदेवा… पारणियाने…\n\nप्रभु तमोने शुं दईए एम रूंवे रूंवे थी गाता,\nआंगण सुधी आवी स्वामी! कोरा कोरा जाता,\nबारमासनां तपसी तमे पण.. हाल अमारा केवा?\nओ देवाधिदेवा… पारणियाने…\n\nवैशाखी त्रीजे प्रभु श्रेयांस कुमारे दीठां\nइक्षुरसनां घडा भरेला व्हालम जेवां मीठां\nऋषभ प्रभुए हाथ लंबाव्या शेरडी रसने लेवा\nओ देवाधिदेवा… पारणियाने…\n\nवसुधारा वरसावे देवो वादळ जाणे वरस्या\nरोग-शोक तो दूर थया जिम स्वयं प्रभुजी स्पर्श्या\n‘उदय’ थयो आ पृथ्वीलोकमां जयजयकारा एवा\nओ देवाधिदेवा… पारणियाने…\n',
    'englishLyrics':
        'પારણિયાને કાજ પધારો… ઓ દેવાધિદેવા…\nપારણિયાને કાજ પધારો… ઓ દેવાધિદેવા…\nવિનવે ઝૂરે ઝંખે લોકો… પ્રભુ! સ્વીકારો સેવા…\nપારણિયાને…\n\nદિવસે ઝંખે રાતે ઝૂરે તન-મન-ધન ને દેતા,\nઋષભ પ્રભુ લેતા નથી કાંઈ એકબીજાને કે’તા,\nનથી સમજાતા રાજા અમારા.. ભાગ્ય રૂઠ્યા છે એવા\nઓ દેવાધિદેવા… પારણિયાને…\n\nપ્રભુ તમોને શું દઈએ એમ રૂંવે રૂંવે થી ગાતા,\nઆંગણ સુધી આવી સ્વામી! કોરા કોરા જાતા,\nબારમાસનાં તપસી તમે પણ.. હાલ અમારા કેવા?\nઓ દેવાધિદેવા… પારણિયાને…\n\nવૈશાખી ત્રીજે પ્રભુ શ્રેયાંસ કુમારે દીઠાં\nઇક્ષુરસનાં ઘડા ભરેલા વ્હાલમ જેવાં મીઠાં\nઋષભ પ્રભુએ હાથ લંબાવ્યા શેરડી રસને લેવા\nઓ દેવાધિદેવા… પારણિયાને…\n\nવસુધારા વરસાવે દેવો વાદળ જાણે વરસ્યા\nરોગ-શોક તો દૂર થયા જિમ સ્વયં પ્રભુજી સ્પર્શ્યા\n‘ઉદય’ થયો આ પૃથ્વીલોકમાં જયજયકારા એવા\nઓ દેવાધિદેવા… પારણિયાને…\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Hriday Parivartan',
    'share': 0,
    'singer': 'Jaydeep Swadiya & Rushabh Katha',
    'songNameEnglish': 'Paraniya Ne Kaj Padharo',
    'songNameHindi': 'पारणियाने काज पधारो',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/fn7yqffw79k',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  String searchKeywords = '';

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void mainSearchKeywords() {
    searchKeywords = searchKeywords +
        currentSongMap['language'] +
        currentSongMap['genre'] +
        removeSpecificString(currentSongMap['tirthankar'], ' Swami') +
        currentSongMap['category'] +
        currentSongMap['songNameEnglish'];
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
        currentSongMap['originalSong'] +
        ' ' +
        currentSongMap['album'] +
        tirthankar +
        originalSong +
        album +
        extra1 +
        extra2 +
        extra3;
    _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }
}
