import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AddSong currentSong = AddSong();
  //Uncomment below to add a new song.

  await currentSong.addToFirestore();
  print('Added song successfully');

  //Uncomment below to add searchKeywords.
  currentSong.makeListOfStrings('EJRD',
      englishName: 'Ek Janmyo Raj Dularo',
      hindiName: 'एक जनम्यो राज दुलारो',
      originalSong: '',
      album: '',
      tirthankar: 'Mahavir',
      extra1: 'Paryushan',
      extra2: '');
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'EJRD',
    'album': '',
    'aaa': 'valid',
    'genre': 'Paryushan | Stavan',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'एक जनम्यो राज दुलारो\nदुनिया नो तरन हारो\nवर्धमान नु नाम धारी\nने प्रगत्यो तेज सितारों र।। \nअवनि पर थी अन्धकार ना\nवादल जाने विखराय (2)\nगाये उमंगें होहो..(2)\nगाये उमंगें गीत अप्सरा,\nदेवो ना मन हरखाया (2)\nनारकी ना देवो ए निरख्यो\nतेज तनो जभकारो र।। \n\nएक जनम्यो राज दुलार\n\nधान वध्या धरती ना पेटे\nनीर वाद्य सरवरिया ना (2)\nचंद्र सूरज ना तेज वाद्य ने\nसांप वाद्य सौ मनाव माँ (2)\nदुःख ना दिवसों दूर तय ने\nआव्यो सुख नो वारो रे।। \n\nएक जनम्यो राज दुलारो\n\nरंकजनों ना दिल माँ प्रसारयु\nआश घरेलू अजवाडु  (2)\nबेली आव्यो होहो..\nबेली आव्यो दिन दुखिया नो\nरहेशे ना कोई नोंधारु (2)\nभीड़ जगत नई भांगे इवो\nसौ नो पालनहारों  रे।। \n\nएक जनम्यो राज दुलारो\n\nवागे  छे  शरणाई  ख़ुशी  नई\nसिद्धार्थ  नो आंगनिये  (2)\nहेते हींछोले  त्रिशला रानी \nबाल कुंवर ने पारणिये (2)\n प्रजा बानी छे आनंद- घेली\nघर घर उत्सव न्यारो रे।। \n\nएक जनम्यो राज दुलारो\nदुनिया नो तरन हारो\nवर्धमान नु नाम धारी\nने प्रगत्यो तेज सितारों र।। \n',
    'originalSong': 'Unknown',
    'production': 'Shemaroo Jai Jinendra',
    'share': 0,
    'singer': 'Mahendra Kapoor | Anuradha Paudwal',
    'songNameEnglish': 'Ek Janmyo Raj Dularo',
    'songNameHindi': 'एक जनम्यो राज दुलारो',
    'tirthankar': 'Mahavir Swami',
    'youTubeLink': 'https://youtu.be/B7EzfJLaabU'
  };
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  Future<void> addToFirestore() async {
    return songs.doc(currentSongMap['code']).set(currentSongMap);
  }

  void makeListOfStrings(
    String code, {
    String englishName: '',
    String hindiName: '',
    String tirthankar: '',
    String originalSong: '',
    String album: '',
    String extra1: '',
    String extra2: '',
  }) {
    Set<String> setSearchKeywords = {};

    String currentString = '';
    for (int i = 0; i < englishName.length; i++) {
      currentString = currentString + englishName[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < hindiName.length; i++) {
      currentString = currentString + hindiName[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < tirthankar.length; i++) {
      currentString = currentString + tirthankar[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < album.length; i++) {
      currentString = currentString + album[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < originalSong.length; i++) {
      currentString = currentString + originalSong[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < extra1.length; i++) {
      currentString = currentString + extra1[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }
    currentString = '';
    for (int i = 0; i < extra2.length; i++) {
      currentString = currentString + extra2[i].toLowerCase();
      setSearchKeywords.add(currentString);
    }

    _addSearchKeywords(code, setSearchKeywords.toList());
  }

  void _addSearchKeywords(String code, List<String> listSearchKeywords) async {
    await songs.doc(code).update({'searchKeywords': listSearchKeywords});
    print('Added Search Keywords successfully');
  }
}
