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
  currentSong.makeListOfStrings('SNVVV',
      englishName: 'Siddhachal Na Vaasi',
      hindiName: 'सिध्दाचल ना वासी',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: 'Adinath',
      extra2: '');
}

class AddSong {
  Map<String, dynamic> currentSongMap = {
    'code': 'SNVVV',
    'album': '',
    'aaa': 'valid',
    'genre': 'Stavan | Bhakti',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'सिध्दाचल ना वासी,विमलाचल ना वासी\nजिनजी प्यारा,आदिनाथने वन्दन हमारा,\nप्रभु जी नु मुखडु मलके,नयनो  माथी वरसे\nअमीरस धारा,आदीनाथने वन्दन हमारा ||\n\nप्रभु जी नु मुखडु छे तेज मिलाकर\nदिल मे भक्ती की ज्योत जमाकर\nभजले प्रभु ने भावे दुर्गती कदी ना आवे |\nजिनजी प्यारा,आदीनाथने वन्दन हमारा…||\n\nअमे तो मोह माया ना विलासी\nतमे छो मुक्ती पुरी ना वासी |\nकर्म बन्धन कापो ,मोक्ष सुख आपो|\nजिनजी  प्यारा,आदिनाथने वन्दन हमारा… ||\n\nभमीने लाख चोरासी हु आव्यो\nपुन्ये दर्शन तुमारा हु पायो |nधन्य दिवस मारो,भवना फेरा टालो |nजिनजी प्यारा आदिनाथने वन्दन हमारा… ||\n\nआरजी उर मा धरजो हमारी |\nअमने आशा छे प्रभुजी तमारी\nकहे प्रसन्न हवे,साचा स्वामी तमे,वन्दन करीले अमे\nजिनजी प्यारा आदिनाथने वन्दन हमारा… ||\n',
    'originalSong': '',
    'production': 'Shemaroo Jai Jinendra',
    'share': 0,
    'singer': 'Sheela Sethia',
    'songNameEnglish': 'Siddhachal Na Vaasi',
    'songNameHindi': 'सिध्दाचल ना वासी',
    'tirthankar': 'Adinath',
    'youTubeLink': 'https://youtu.be/9bex5sXUFB0'
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
