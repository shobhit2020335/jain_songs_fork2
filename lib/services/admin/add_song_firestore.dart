import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/services/admin/export_firestore.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  //Firebase Anonymous signIn.
  Globals.userCredential = await FirebaseAuth.instance.signInAnonymously();

  // runApp(const MainTheme());

  AddSong currentSong = AddSong(app);

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  //Uncomment below to sync songData with original song values.
  // await currentSong.rewriteSongsDataInFirebase();

  //This automatically creates searchKeywords from song details.
  currentSong.mainSearchKeywords();

  //Uncomment Below to add EXTRA searchkeywords in form of string.
  currentSong.extraSearchKeywords('BRPT',
      englishName: 'akhateej tij',
      hindiName: 'अदीश्वर् aadishwar',
      originalSong: 'aadinath',
      album: 'baapalda patikda tume',
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
    debugPrint('Error: ' + error);
  });
  debugPrint('Added song successfully');

  //Uncomment below to add song in realtimeDB.
  await currentSong.addToRealtimeDB().catchError((error) {
    debugPrint('Error: ' + error);
  }).then((value) {
    debugPrint('Added song to realtimeDB successfully');
  });

  //Comment below to stop adding songsData
  await currentSong.addsongsDataInFirebase();
}

class MainTheme extends StatefulWidget {
  const MainTheme({Key? key}) : super(key: key);

  @override
  State<MainTheme> createState() => _MainThemeState();
}

class _MainThemeState extends State<MainTheme> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userBehaviourJson = 'Pakau';
    ExportFirestore exportFirestore = ExportFirestore();

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Row(
              children: [
                TextButton(
                  onPressed: () async {
                    userBehaviourJson =
                        await exportFirestore.getUserBehaviourToJson();
                  },
                  child: const Text('Fetch'),
                ),
                TextButton(
                  onPressed: () async {
                    await exportFirestore.storeInTextFile(userBehaviourJson);
                  },
                  child: const Text('Store'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddSong {
  final FirebaseApp app;

  AddSong(this.app);

  Map<String, dynamic> currentSongMap = {
    'code': 'BRPT',
    'album': '',
    'aaa': 'valid',
    'category': 'Stavan',
    'genre': 'Tapasya',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics':
        'बापलडा रे पातिकडा तमे, शुं करशो हवे रहीने रे;\nश्री सिध्धाचल नयणे निरख्यो, दूर जाओ तमे वहीने रे... १\n\nकाल अनादि लगे तुम साथे, प्रीत करी निरवहीने रे;\nआज थकी प्रभु चरणे रहेवुं ऐम शीखवीयुं मनने रे... २\n\nदुषम काळे ईणे भरते, मुक्ति नहीं संघयणने रे;\nपण तुम भक्ति मुक्तिने खेंचे, चमक पाषाण जेम लोहने रे... ३\n\nशुध्द सुवासन चूरण आप्युं, मिथ्यापंक शोधनने रे:\nआतम भाव थयो मुज निर्मळ, आनंदमय तुज भजने रे... ४\n\nअक्षय निधान तुज समकित पामी, कुण वंछे चल धनने रे;\nशांत सुधारस नयण कचोळे, सींचो सेवक तनने रे... ५\n\nबाह्य अभ्यंतर शत्रु केरो, भय न होवे मुजने रे;\nसेवक सुखीयो सुजस विलासी, ऐ महिमा प्रमु तुजने रे...६\n\nनाम मंत्र तुमारो साध्यो, ते थयो जग मोहनने रे;\nतुज मुख मुद्रा निरखीने हरखुं, जेम चातक जलधरने रे... ७\n\nतुज विण अवरने देव करीने, नवि चाहुं फरी फरीने रे;\n"ज्ञानविमल" कहे भवजल तारो, सेवक बाह्य ग्रहीने रे...८\n',
    'englishLyrics': '',
    'originalSong': '',
    'popularity': 0,
    'production': 'Jain Media',
    'share': 0,
    'singer': 'Foram Prasham Shah',
    'songNameEnglish': 'Bapalda Re Paatikda Tame',
    'songNameHindi': 'बापलडा रे पातिकडा तमे',
    'tirthankar': 'Adinath',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/RfZuEyLjYwM',
  };
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  CollectionReference suggestion =
      FirebaseFirestore.instance.collection('suggestions');

  String searchKeywords = '';

  Future<void> deleteSuggestion(String uid) async {
    return suggestion.doc(uid).delete().then((value) {
      debugPrint('Deleted Successfully');
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
    String englishName = '',
    String hindiName = '',
    String tirthankar = '',
    String originalSong = '',
    String album = '',
    String extra1 = '',
    String extra2 = '',
    String extra3 = '',
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
      if (searchWordsList[i].isNotEmpty) {
        searchKeywords += ' ' + searchWordsList[i];
      }
    }
    currentSongMap['searchKeywords'] = searchKeywords;
    currentSongMap['lastModifiedTime'] =
        Timestamp.fromDate(DateTime(2020, 12, 25, 12));
    // _addSearchKeywords(code, searchKeywords.toLowerCase());
  }

  Future<void> addToRealtimeDB() async {
    Timestamp timestamp = currentSongMap['lastModifiedTime'];
    currentSongMap['lastModifiedTime'] = timestamp.millisecondsSinceEpoch;
    FirebaseDatabase.instanceFor(app: app)
        .ref()
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

      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('likes')
          .update({
        currentSongMap['code']: currentSongMap['likes'],
      });
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('share')
          .update({
        currentSongMap['code']: currentSongMap['share'],
      });
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('todayClicks')
          .update({
        currentSongMap['code']: currentSongMap['todayClicks'],
      });
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('totalClicks')
          .update({
        currentSongMap['code']: currentSongMap['totalClicks'],
      });
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('popularity')
          .update({
        currentSongMap['code']: currentSongMap['popularity'],
      });
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('trendPoints')
          .update({
        currentSongMap['code']: currentSongMap['trendPoints'],
      });
      debugPrint('songData added successfully');
    } catch (e) {
      debugPrint('Error writing songsData: $e');
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
          await songs.get(const GetOptions(source: Source.cache));

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

      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('likes')
          .set(likesMap);
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('share')
          .set(shareMap);
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('todayClicks')
          .set(todayClicksMap);
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('totalClicks')
          .set(totalClicksMap);
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('popularity')
          .set(popularityMap);
      await FirebaseDatabase.instanceFor(app: app)
          .ref()
          .child('songsData')
          .child('trendPoints')
          .set(trendPointsMap);
      debugPrint('Rewritten songsData successfully');
    } catch (e) {
      debugPrint('Error rewriting songsData: $e');
    }
  }
}
