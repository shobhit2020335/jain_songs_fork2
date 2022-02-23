import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  //Firebase Anonymous signIn.
  Globals.userCredential = await FirebaseAuth.instance.signInAnonymously();

  AddSong currentSong = AddSong(app);

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  //Uncomment below to sync songData with original song values.
  // await currentSong.rewriteSongsDataInFirebase();

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment Below to add EXTRA searchkeywords in form of string.
  currentSong.extraSearchKeywords('OJMP',
      englishName: 'jay mahabir prabho',
      hindiName: '',
      originalSong: '',
      album: '',
      tirthankar: '',
      extra1: '',
      extra2: '',
      extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  // pajushan parushan paryusan pajyushan bhairav parasnath parshwanath
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
  }).then((value) {
    print('Added song to realtimeDB successfully');
  });

  //Comment below to stop adding songsData
  await currentSong.addsongsDataInFirebase();
}

class AddSong {
  final FirebaseApp app;

  AddSong(this.app);

  Map<String, dynamic> currentSongMap = {
    'code': 'OJMP',
    'album': '',
    'aaa': 'valid',
    'category': 'Aarti',
    'genre': '',
    'gujaratiLyrics': '',
    'language': 'Hindi',
    'likes': 0,
    'lyrics':
        'Jai Mahavir Prabho,Swami Jai Mahavir Prabho\nJannaayak Sukhdaayak,Ati gambhir prabho || ॐ ||\n\nKundalpur me janme, trishla ke jaaye\nPita Sidhaarth raja, Sun nar Harshaye || ॐ ||\n\nDeennath dayanidhi, hai mangal kaari\nJaghit saiyam dhara, Prabhu par-upkaari || ॐ ||\n\nPaapachar mitaya, Satpath dikhlaya\nDayadharm ka jhanda, Jag me lehraya || ॐ ||\n\nArjunmaali Gautam, Shri chandanbala\nPaar jagat se beda, Inka Kar daala || ॐ ||\nPaawan naam tumhara, jag taaranhara\nNisidin jo nar dhyave, Kasht mitay saara || ॐ ||\n\nKaruna sagar, teri mahima hai nyaari\nGyanmuni gun gaave, charanan balihaari || ॐ ||\n ',
    'englishLyrics':
        'ॐ जय महावीर प्रभु,\nस्वामी जय महावीर प्रभु ।\nकुण्डलपुर अवतारी,\nचांदनपुर अवतारी,\nत्रिशलानंद विभु ॥\n\nसिध्धारथ घर जन्मे,\nवैभव था भारी ।\nबाल ब्रह्मचारी व्रत,\nपाल्यो तप धारी ॥\n॥ॐ जय महावीर प्रभु...॥\n\nआतम ज्ञान विरागी,\nसम दृष्टि धारी ।\nमाया मोह विनाशक,\nज्ञान ज्योति जारी ॥\n॥ॐ जय महावीर प्रभु...॥\n\nजग में पाठ अहिंसा,\nआप ही विस्तारयो ।\nहिंसा पाप मिटा कर,\nसुधर्म परिचारियो ॥\n॥ॐ जय महावीर प्रभु...॥\n\nअमर चंद को सपना,\nतुमने परभू दीना ।\nमंदिर तीन शेखर का,\nनिर्मित है कीना ॥\n॥ॐ जय महावीर प्रभु...॥\n\nजयपुर नृप भी तेरे,\nअतिशय के सेवी ।\nएक ग्राम तिन्ह दीनो,\nसेवा हित यह भी ॥\n॥ॐ जय महावीर प्रभु...॥\n\nजल में भिन्न कमल जो,\nघर में बाल यति ।\nराज पाठ सब त्यागे,\nममता मोह हती ॥\n॥ॐ जय महावीर प्रभु...॥\n \nभूमंडल चांदनपुर,\nमंदिर मध्य लसे ।\nशांत जिनिश्वर मूरत,\nदर्शन पाप लसे ॥\n॥ॐ जय महावीर प्रभु...॥\n\nजो कोई तेरे दर पर,\nइच्छा कर आवे ।\nधन सुत्त सब कुछ पावे,\nसंकट मिट जावे ॥\n॥ॐ जय महावीर प्रभु...॥\n\nनिशदिन प्रभु मंदिर में,\nजगमग ज्योत जरे ।\nहम सेवक चरणों में,\nआनंद मूँद भरे ॥\n॥ॐ जय महावीर प्रभु...॥\n\nॐ जय महावीर प्रभु,\nस्वामी जय महावीर प्रभु ।\nकुण्डलपुर अवतारी,\nचांदनपुर अवतारी,\nत्रिशलानंद विभु ॥\n ',
    'originalSong': '',
    'popularity': 0,
    'production': 'Brijwani Cassettes',
    'share': 0,
    'singer': 'Vandana Bhardwaj',
    'songNameEnglish': 'Om Jai Mahaveer Prabhu',
    'songNameHindi': 'ॐ जय महावीर प्रभु',
    'tirthankar': 'Mahavir',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/HKcJ0vmMYV4',
  };
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        ' ' +
        currentSongMap['singer'];
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
    currentSongMap['lastModifiedTime'] =
        Timestamp.fromDate(DateTime(2020, 12, 25, 12));
    // _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  //Directly writing search keywords so not required now.
  void _addSearchKeywords(String code, String stringSearchKeyword) async {
    await songs.doc(code).update({'searchKeywords': stringSearchKeyword});

    print('Added Search Keywords successfully');
  }

  Future<void> addToRealtimeDB() async {
    Timestamp timestamp = currentSongMap['lastModifiedTime'];
    currentSongMap['lastModifiedTime'] = timestamp.millisecondsSinceEpoch;
    FirebaseDatabase(app: this.app)
        .reference()
        .child('songs')
        .child(currentSongMap['code'])
        .set(currentSongMap);
  }

  //This adds data to firestore songsData and realtimeDB songsData.
  Future<void> addsongsDataInFirebase() async {
    try {
      await _firestore.collection('songsData').doc('likes').update({
        currentSongMap['code']: currentSongMap['likes'],
      });
      await _firestore.collection('songsData').doc('share').update({
        currentSongMap['code']: currentSongMap['share'],
      });
      await _firestore.collection('songsData').doc('todayClicks').update({
        currentSongMap['code']: currentSongMap['todayClicks'],
      });
      await _firestore.collection('songsData').doc('totalClicks').update({
        currentSongMap['code']: currentSongMap['totalClicks'],
      });
      await _firestore.collection('songsData').doc('popularity').update({
        currentSongMap['code']: currentSongMap['popularity'],
      });
      await _firestore.collection('songsData').doc('trendPoints').update({
        currentSongMap['code']: currentSongMap['trendPoints'],
      });

      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('likes')
          .update({
        currentSongMap['code']: currentSongMap['likes'],
      });
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('share')
          .update({
        currentSongMap['code']: currentSongMap['share'],
      });
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('todayClicks')
          .update({
        currentSongMap['code']: currentSongMap['todayClicks'],
      });
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('totalClicks')
          .update({
        currentSongMap['code']: currentSongMap['totalClicks'],
      });
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('popularity')
          .update({
        currentSongMap['code']: currentSongMap['popularity'],
      });
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('trendPoints')
          .update({
        currentSongMap['code']: currentSongMap['trendPoints'],
      });
      print('songData added successfully');
    } catch (e) {
      print('Error writing songsData: $e');
    }
  }

  //Rewrite songsData
  Future<void> rewriteSongsDataInFirebase() async {
    try {
      Map<String, int> likesMap = {};
      Map<String, int> shareMap = {};
      Map<String, int> todayClicksMap = {};
      Map<String, int> totalClicksMap = {};
      Map<String, int> popularityMap = {};
      Map<String, double> trendPointsMap = {};
      QuerySnapshot querySnapshot =
          await songs.get(GetOptions(source: Source.cache));

      for (var song in querySnapshot.docs) {
        Map<String, dynamic> currentSong = song.data() as Map<String, dynamic>;
        String state = currentSong['aaa'];
        state = state.toLowerCase();
        if (state.contains('invalid') != true) {
          likesMap[currentSong['code']] = currentSong['likes'];
          shareMap[currentSong['code']] = currentSong['share'];
          todayClicksMap[currentSong['code']] = currentSong['todayClicks'];
          totalClicksMap[currentSong['code']] = currentSong['totalClicks'];
          popularityMap[currentSong['code']] = currentSong['popularity'];
          trendPointsMap[currentSong['code']] = currentSong['trendPoints'];
        }
      }

      await _firestore.collection('songsData').doc('likes').set(likesMap);
      await _firestore.collection('songsData').doc('share').set(shareMap);
      await _firestore
          .collection('songsData')
          .doc('todayClicks')
          .set(todayClicksMap);
      await _firestore
          .collection('songsData')
          .doc('totalClicks')
          .set(totalClicksMap);
      await _firestore
          .collection('songsData')
          .doc('popularity')
          .set(popularityMap);
      await _firestore
          .collection('songsData')
          .doc('trendPoints')
          .set(trendPointsMap);

      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('likes')
          .set(likesMap);
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('share')
          .set(shareMap);
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('todayClicks')
          .set(todayClicksMap);
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('totalClicks')
          .set(totalClicksMap);
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('popularity')
          .set(popularityMap);
      await FirebaseDatabase(app: this.app)
          .reference()
          .child('songsData')
          .child('trendPoints')
          .set(trendPointsMap);
      print('Rewritten songsData successfully');
    } catch (e) {
      print('Error rewriting songsData: $e');
    }
  }
}
