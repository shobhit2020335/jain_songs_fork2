import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();

  AddSong currentSong = AddSong(app);

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment Below to add searchkeywords in form of string.
  currentSong.extraSearchKeywords('EVNMSJN',
      englishName: 'એક વાર નેમ મારી સામુ જુઓને',
      hindiName: 'var mara same juo na',
      originalSong: 'nemnath',
      album: 'bar',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ सतव जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  //शत्रुंजय shatrunjay siddhgiri siddhagiri पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak

  //Uncomment below to add a new song.
  await currentSong.addToFirestore().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song successfully');

  //Uncomment below to add song in realtimeDB.
  await currentSong.addToRealtimeDB().catchError((error) {
    print('Error: ' + error);
  });
  print('Added song to realtimeDB successfully');
}

class AddSong {
  final FirebaseApp app;

  AddSong(this.app);

  Map<String, dynamic> currentSongMap = {
    'code': 'EVNMSJN',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': '',
    'gujaratiLyrics':
        'સામુ જુઓ ને મારી સામુ જુઓ ને,\nએક વાર નેમ મારી સામુ જુઓને\nકરુણા દૃષ્ટિ થી મારે સામુ જુઓને,\nઅમિદૃષ્ટિ થી મારી સામુ જુઓને\nસામુ જુઓ…\n\nનિગોદ ના દિવસોં મને યાદજ આવતા,\nહું અને તૂ રહ્યા એકજ ધામ મા\nઅનાદિ કાળ થી દુઃખો ને ખમતા,\nઆ ચૌરાસી લાખ યોનિ મા ભમતા\nભવો ભવ સુધી સાથે રહ્યા,\nઆજે મને કેમ છોડી ગયા\nતારા વિના દાદા મને કૌન પૂછે ના,\nમારી આંખીયો ના આંસૂ કોણ લુછે ના\nસામુ જુઓ…\n\nસંસાર અસાર છે મોક્ષજ સાર છે,\nતારી વાતો મેં તો સુની નલવાર છે\nમોહ માયા ના ઝૂલે હુ ઝુલિયો,\nરાચી માચી ને કર્મો મેં બાંધ્યા\nહસ્તા હસ્તા કર્મો મેં બાંધ્યા,\nઆત્મા મા કર્મો ના ઢગલા ભર્યા\nરોતા રોતા આજ-મારા કર્મો છુટે ના,\nદુઃખો ના ડૂંગર-મારા આજ ટૂટે ના\nસામુ જુઓ…\n\nછેલ્લી વિનંતી મારી દાદા તૂ સુણજે,\nઅંત સમયે મુજને તું મલજે\nપીડા જ્યારે રગ-રગ માંથી વ્યાપે,\nતારા દર્શન ની ઠંડક તું આપજે\nઝંજાલ જગની છોડી ગઈ,\nમને તારા ધ્યાન મા સ્થિર કરી\nસમાધિ મરણ-મલે એવું હુ માંગુ,\nભવ ભવના ફેરા ટલે એવું હુ માંગુ\nસામુ જુઓ…\n',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'सामु जुओ ने मारी सामु जुओ ने,\nएक वार नेम मारी सामु जुओने\nकरुणा दृष्टि थी मारे सामु जुओने,\nअमिदृष्टि थी मारी सामु जुओने\nसामु जुओ…\n\nनिगोद ना दिवसों मने यादज आवता,\nहुं अने तू रह्या एकज धाम मा\nअनादि काळ थी दुःखो ने खमता,\nआ चौरासी लाख योनि मा भमता\nभवो भव सुधी साथे रह्या,\nआजे मने केम छोडी गया\nतारा विना दादा मने कौन पूछे ना,\nमारी आंखीयो ना आंसू कोण लुछे ना\nसामु जुओ…\n\nसंसार असार छे मोक्षज सार छे,\nतारी वातो में तो सुनी नलवार छे\nमोह माया ना झूले हु झुलियो,\nराची माची ने कर्मो में बांध्या\nहस्ता हस्ता कर्मो में बांध्या,\nआत्मा मा कर्मो ना ढगला भर्या\nरोता रोता आज-मारा कर्मो छुटे ना,\nदुःखो ना डूंगर-मारा आज टूटे ना\nसामु जुओ…\n\nछेल्ली विनंती मारी दादा तू सुणजे,\nअंत समये मुजने तुं मलजे\nपीडा ज्यारे रग-रग मांथी व्यापे,\nतारा दर्शन नी ठंडक तुं आपजे\nझंजाल जगनी छोडी गई,\nमने तारा ध्यान मा स्थिर करी\nसमाधि मरण-मले एवुं हु मांगु,\nभव भवना फेरा टले एवुं हु मांगु\nसामु जुओ…\n',
    'englishLyrics':
        'Samu Juo Ne Mari Samu Juone ,\nEk Var Nema Mari Samu Juone\nKaruna Drushti Thi Mare Samu Juone ,\nAmidrushti Thi Mari Samu Juone\n\nNigoda Na Divason Mane Yaadaj Aavata ,\nHu Ane Tu Rahya Ekaja Dhama Ma\nAnadi Kala Thi Duahkho Ne Khamata,\nAa Chaurasi Lakha Yoni Ma Bhamata\nBhavo Bhava Sudhi Sathe Rahya ,\nAaje Mane Kema Chodi Gaya\nTara Vina Dada Mane Kaun Puche Na ,\nMari Aankhiyo Na Aasu Kaun Luche Na\n\nSansar Asara Che Mokshaj Saar Che ,\nTari Vato Main to Suni Nalavara Che,\nMoha Maya Na Jule Hu Juliyo ,\nRachi Machi Ne Karmo Main Bandhya,\nHasta Hasta Karmo Main Bandhya ,\nAatma Ma Karmo Na Dhagala Bharya\nRota Rota Aaja Mara Karmo Chute Na,\nDuahkho Na Dungara Mara Aaja Tute Na\n\nChelli Vinanti Mari Dada Tu Sun Je ,\nAnta Samaye Mujne Tu Malaje ,\nPida Jyare Raga Raga Mathi Vyape ,\nTara Darshana Ni Thandaka Tu Aapaje,\nJanjala Jagani Chodi Gai ,\nMane Tara Dhyana Ma Sthira Kari,\nSamadhi Marana Male Evu Hu Mangu ,\nBhava Bhavana Fera Tale Evu Hu Mangu\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jin Stavan',
    'share': 0,
    'singer': '',
    'songNameEnglish': 'Ek Vaar Nem Mari Samu Juo Ne',
    'songNameHindi': 'एक वार नेम मारी सामु जुओने',
    'tirthankar': 'Neminath',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/9jravVqNlwI',
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestion =
      FirebaseFirestore.instance.collection('suggestions');

  String searchKeywords = '';

  Future<void> deleteSuggestion(String uid) async {
    return suggestion.doc(uid).delete().then((value) {
      print('Deleted Successfully');
    });
  }

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
    searchKeywords =
        searchKeywords.toLowerCase() + ' ' + englishName + ' ' + hindiName;
    searchKeywords = searchKeywords +
        ' ' +
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
    List<String> searchWordsList = searchKeywords.toLowerCase().split(' ');
    searchKeywords = "";
    for (int i = 0; i < searchWordsList.length; i++) {
      if (searchWordsList[i].length > 0) {
        searchKeywords += ' ' + searchWordsList[i];
      }
    }
    currentSongMap['searchKeywords'] = searchKeywords;
    // _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  //Directly writing search keywords so not required now.
  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }

  Future<void> addToRealtimeDB() async {
    FirebaseDatabase(app: this.app)
        .reference()
        .child('songs')
        .child(currentSongMap['code'])
        .set(currentSongMap);
  }
}
