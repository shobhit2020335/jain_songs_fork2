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
  currentSong.makestringSearchKeyword('HTNTT',
      englishName: 'Have Tara Nai Tam Tame Have Tara Nahi Tam Tame',
      hindiName: '',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: 'Jainam Varia',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'HTNTT',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Diksha',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'हवे तारा नई तम तमे आ आंगने\nएक सैयाम नो तारलो जळहळे रे लोल\nहवे पूनम नई आवे मारा बारने\nमारा आँसू नो दरियो घडवाडे रे लोल\nहवे तारा नई तम तमे आ आंगने\nएक सैयाम नो तारलो जळहळे रे लोल\n\nमारा पालव नो प्रेम आ तो छोड़ी गयो\nऐना मंगमता आकाशे दोड़ी गयो\nएने मुकि छे...\nएने मुकि छे ममता नी मोजड़ी\nप्रभु प्रीति नी बांधसे कसदि\nहवे तारा नई तम तमे आ आंगने\nएक सैयाम नो तारलो जळहळे रे लोल\n\nतू पिता प्रेम नो क्यारो हतो\nधन वैभव ने पेढ़ी नो वारस हतो\nजिन शाशन नी...\nजिन शाशन नी शान ने वधारषे\nएमा महाव्रत नी मोह लगावशे रे लोल\nहवे तारा नई तम तमे आ आंगने\nएक सैयाम नो तारलो जळहळे रे लोल\n\nकाली शेरीमाँ बालपने रमतो हतो\nभाई बेहेन नी संगते जमतो हतो\nकेम अनधारयो....\nकेम अनधारयो तहको आ मोरलो\nएने आवे छे सैयाम ना शोनला रे लोल\nहवे तारा नई तम तमे आ आंगने\nएक सैयाम नो तारलो जळहळे रे लोल\n\nभोग सुखो ना शामनाओ छूटता नाता\nसुख मानवा मा दिवसों पान खुट्टा नाता\nभर यौवन मा...\nभर यौवन मा त्याग पंथे मोहातो\nआ तो सैयाम ना शणगारे सोहातो जाय\nहवे तारा नई तम तमे आ आंगने\nएक सैयाम नो तारलो जळहळे रे लोल\n\nआ धरती तू बजे ने कोमल सदा\nमारा लाडला ने खुप ना काकरा काढ़ा\nआ तो  चाल्यो छे...\nआ तो चाल्यो छे कशता नी केडीए\nएने पादशे रे अष्ट अष्ट मावड़ी रे लोल\nहवे तारा नई तम तमे आ आंगने\nएक सैयाम नो तारलो जळहळे रे लोल\nएक सैयाम नो तारलो जळहळे रे लोल\nएक सैयाम नो तारलो जळहळे रे लोल\n',
    'englishLyrics':
        'Have taaraa nai tam tame aa aangane\nEk saiyam no taarlo jalhale re lol\nHave poonam nai aave maaraa baarane\nMaaraa aasu no dariyo ghadvade re lol\nHave taaraa nai tam tame aa aangane\nEk saiyam no taarlo jalhale re lol\n\nMaaraa paalav no prem a to chodi gayo\nEna mangamta aakaashe dodi gayo\nEne muki che....\nEne muki che mamta ni mojadi\nPrabu priti ni bandhse kasadi\nHave taaraa nai tam tame aa aangane\nEk saiyam no taarlo jalhale re lol\n\nTu pita prem no kyaaro hato\nDhan vaibhav ne pedhi no vaaras hato\nJin shaashan ni...\nJin shaashan ni shaan ne vadharshe\nEma mahavrat ni moh lagavshe re lol\nHave taaraa nai tam tame aa aangane\nEk saiyam no taarlo jalhale re lol\n\nKaali sheri ma baalpane ramto hato\nBhai behen ni sangaate jamto hato\nKem anadhaaryo....\nKem anadhaaryo tahuko aa moralo\nEne aave che saiyam na shonala re lol\nHave taaraa nai tam tame aa aangane\nEk saiyam no taarlo jalhale re lol\n\nBhog sukho na shamanao chutata nata\nSukh maanavaa maa divaso pan khutata nata\nBhar yovan maa...\nBhar yovan maa tyaag panthe mohaato\nA to saiyam na shanagaare sohato jaay\nHave taaraa nai tam tame aa aangane\nEk saiyam no taarlo jalhale re lol\n\nA dharti tu banje ne komal sada\nMaaraa laadalaa ne khupe naa kaakaraa kada\nA to chaalyo che...\nA to chaalyo che kashta ni kediye\nEne paadashe re ashta ashta maavadi re lol\nHave taaraa nai tam tame aa aangane\nEk saiyam no taarlo jalhale re lol\nEk saiyam no taarlo jalhale re lol\nEk saiyam no taarlo jalhale re lol\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Virti Vivah',
    'share': 0,
    'singer': 'Jainam Varia',
    'songNameEnglish': 'Have Tara Nai Tam Tame',
    'songNameHindi': '',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/F6DFXtFCmzA',
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
