import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';
import 'package:jain_songs/services/admin/export_firestore.dart';
import 'package:jain_songs/services/services.dart';
import 'package:jain_songs/services/useful_functions.dart';
import 'package:jain_songs/utilities/globals.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  FirebaseApp app = await Firebase.initializeApp();
  //Firebase Anonymous signIn.
  Globals.userCredential = await FirebaseAuth.instance.signInAnonymously();

  runApp(const MainTheme());

  // AddSong currentSong = AddSong(app);

  // currentSong.deleteSuggestion('chalomanagangs C0ww80');

  // //Uncomment below to sync songData with original song values.
  // // await currentSong.rewriteSongsDataInFirebase();

  //This automatically creates searchKeywords from song details.
  // currentSong.mainSearchKeywords();

  /////////////// UPLOAD AACG FIRST ////////////////////
  //Uncomment Below to add EXTRA searchkeywords in form of string.
  // currentSong.extraSearchKeywords('AACG',
  //     englishName:
  //         /////////////// UPLOAD AACG FIRST ////////////////////
  //         'aatmodhare aatmadare aatmadhare aatamodhare aatmoddhhare aatmoddhare aatmodhhare',
  //     hindiName: 'chala chale gya gayi gyi gyo gayo',
  //     originalSong: 'diksa dikhsa',
  //     album: '',
  //     tirthankar: '',
  //     extra1: '',
  //     extra2: '',
  //     extra3: '');
  //पारसनाथ पार्श्वनाथ महावीर दीक्षा शांती नाथ जनम कल्याणक दादा अदीश्वर् स्तोत्र નેમિનાથ नेमिनाथ
  // pajushan parushan paryusan pajyushan bhairav parasnath parshwanath
  //शत्रुंजय shatrunjay siddhgiri siddhagiri पालीताना पालीताणा Bhikshu Swami Bikshu swami भिक्षू Varsitap parna
  //महावीर जनम कल्याणक mahavir jayanti mahavir janam kalyanak mahaveer janma kalyanak

  //Uncomment below to add a new song.
  // await currentSong.addToFirestore().catchError((error) {
  //   debugPrint('Error: ' + error);
  // });
  // debugPrint('Added song successfully');

  //Uncomment below to add song in realtimeDB.
  // await currentSong.addToRealtimeDB().catchError((error) {
  //   debugPrint('Error: ' + error);
  // }).then((value) {
  //   debugPrint('Added song to realtimeDB successfully');
  // });

  //Uncomment below to add songsData
  // await currentSong.addsongsDataInFirebase();
}

class AddSong {
  final FirebaseApp app;

  AddSong(this.app);

  Map<String, dynamic> currentSongMap = {
    'code': 'AACG',
    'album': '',
    /////////////// UPLOAD AACG FIRST ////////////////////
    'aaa': 'valid',
    'category': 'Song | Stavan',
    'genre': 'Diksha | Latest',
    'gujaratiLyrics': '',
    'language': 'Gujarati',
    'likes': 0,
    'lyrics': '',
    'englishLyrics':
        'એ આત્મોદ્ધારે ચાલી ગયા,\nજોડી રહ્યા એ ગુરુકુળવાસ,\nએ સંસાર આખો છોડી રહ્યાં...\nપ્રિય માત-તાત સંતાન છોડી.... એ આત્મોદ્ધારે…\n\nકેસર રૂડા છંટાયા,\nછાબો ભરાઇ એની...\nવર્ષોથી સેવેલા સપના,\nસાકાર કરાવો અહીં...\nપ્રભુ આણમાં પળપળ રહી,\nગુર્વાજ્ઞા પાળે અહોભાવે,\nએ આત્મોદ્ધારે….\n\nવિધિ સુંદર નંદિની, સંસાર નિકંદીની,\nજુઓ ધારા સદીઓની, હરપળ આનંદીની,\nમુંડાયું એનું મન, બન્યા હવે શ્રમણ,\nપામ્યા સંયમ જીવન, કરશે સાધના ઉજ્જવળ...\nપ્રભુ આણમાં….\n\nનામની કામના ખૂંચે, ગુરુ કેશને લૂંચે,\nભાવ એના ચડે ઊંચે, ગુરુ નિશ્રા ના મુંચે,\nઅરે! એના સત્વથી,હૈંયા સૌના હરશે (હર્ષે),\nજિનાગમ શ્રુત પામી, એ જયન્ત પદ વરશે...\nપ્રભુ આણમાં….\n',
    'originalSong': '',
    'popularity': 0,
    'production': 'मधुकर સંસ્કાર GYANAYATAN',
    'share': 0,
    'singer': 'Manan Sanghvi',
    'songNameEnglish': 'Ae Aatmoddhare Chali Gaya',
    'songNameHindi': 'आ आत्मोद्धारे चली गया',
    'tirthankar': '',
    'totalClicks': 0,
    'todayClicks': 0,
    'trendPoints': 0.0,
    'youTubeLink': 'https://youtu.be/0WtNHe7fXc0',
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

class MainTheme extends StatefulWidget {
  const MainTheme({Key? key}) : super(key: key);

  @override
  State<MainTheme> createState() => _MainThemeState();
}

class _MainThemeState extends State<MainTheme> {
  var countController = TextEditingController();
  int countOfDataToFetch = 10;
  String userBehaviourJson =
      'Dead text to see if its storing the text file in phone';
  String debugLog = 'No logs';
  ExportFirestore exportFirestore = ExportFirestore();
  bool showProgress = false;

  @override
  void initState() {
    super.initState();
    countController.text = countOfDataToFetch.toString();
  }

  @override
  void dispose() {
    countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
              child: showProgress
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextField(
                          controller: countController,
                          onChanged: (value) {
                            countOfDataToFetch = int.parse(value);
                          },
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Count of Data to fetch',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              showProgress = true;
                            });
                            debugLog = 'fetching';
                            userBehaviourJson =
                                await exportFirestore.getUserBehaviourToJson(
                                    countOfDataToFetch: countOfDataToFetch);
                            debugLog = 'Fetched and Deleted';
                            setState(() {
                              showProgress = false;
                            });
                          },
                          child: const Text('Fetch'),
                        ),
                        TextButton(
                          onPressed: () async {
                            bool isStoragePermissionGranted =
                                await Services.requestPermission(
                                    Permission.storage);

                            if (isStoragePermissionGranted) {
                              setState(() {
                                showProgress = true;
                              });

                              // ConstWidget.showSimpleToast(
                              //     context, 'Storage permission granted');

                              debugLog = await exportFirestore
                                  .storeInTextFile(userBehaviourJson);

                              setState(() {
                                showProgress = false;
                              });

                              // ConstWidget.showSimpleToast(context, status);
                            } else {
                              debugPrint('Storage permission not granted');
                              debugLog = 'Storage permission denied';
                            }
                          },
                          child: const Text('Store'),
                        ),
                        Text(
                          debugLog,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
