import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/buildList.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/songs_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //The user is redirected to offline page if he is offline
  int _currentIndex = 0;
  bool showProgress = false;
  final _firestore = FirebaseFirestore.instance;

  void getSongs() async {
    final songs = await _firestore.collection('songs').get();
    for (var song in songs.docs) {
      Map<String, dynamic> currentSong = song.data();
      songList.add(
        SongDetails(
          code: currentSong['code'],
          lyrics: currentSong['lyrics'],
          songNameEnglish: currentSong['songNameEnglish'],
          songNameHindi: currentSong['songNameHindi'],
          originalSong: currentSong['originalSong'],
          likes: currentSong['likes'],
          share: currentSong['share'],
        ),
      );
    }
    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    showProgress = true;
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jain Songs',
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.archive),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wrench),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Color(0xFF54BEE6),
        unselectedItemColor: Color(0xFF212323),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: <Widget>[
        BuildList(
          showProgress: showProgress,
        ),
        Container(
          child: Center(
            child: SizedBox(
              child: Center(
                child: Text('Press'),
              ),
              height: 50,
              width: 80,
            ),
          ),
        ),
        Container(
          child: Center(
            child: SizedBox(
              child: Center(
                child: Text(
                  'Press3',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              height: 50,
              width: 80,
            ),
          ),
        ),
        Container(
          child: Center(
            child: SizedBox(
              child: Center(
                child: Text(
                  'Press4',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              height: 50,
              width: 80,
            ),
          ),
        ),
      ][_currentIndex],
    );
  }
}
