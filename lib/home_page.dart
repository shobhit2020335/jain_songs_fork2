import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/services/network_helper.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/songs_list.dart';
import 'song_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //The user is redirected to offline page if he is offline
  int _currentIndex = 2;
  bool showProgress = false;
  final _firestore = FirebaseFirestore.instance;

  void getSongs() async {
    print('ghusa');
    final songs = await _firestore.collection('songs').get();

    for (var song in songs.docs) {
      print(song.data());
    }
    setState(() {
      showProgress = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future connection = NetworkHelper().check();
    connection.then((result) {
      if (result == true) {
        setState(() {
          _currentIndex = 0;
          showProgress = true;
        });
        getSongs();
      } else {
        showProgress = false;
        //TODO: insert snackbar here.
        print('no internet');
      }
    });
  }

  Widget _buildRow(SongDetails currentSong) {
    return ListTileTheme(
      selectedColor: Colors.white,
      style: ListTileStyle.drawer,
      child: ListTile(
        title: Text(
          currentSong.songNameEnglish,
          style: TextStyle(color: Color(0xFF212323)),
        ),
        subtitle: Text(currentSong.originalSong),
        trailing: IconButton(
          icon: Icon(currentSong.isLiked == true
              ? FontAwesomeIcons.solidHeart
              : FontAwesomeIcons.heart),
          onPressed: () {
            setState(() {
              if (currentSong.isLiked == true) {
                currentSong.isLiked = false;
                currentSong.likes--;
              } else {
                currentSong.isLiked = true;
                currentSong.likes++;
              }
            });
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongPage(currentSong: currentSong),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    return ModalProgressHUD(
      opacity: 1,
      inAsyncCall: showProgress,
      child: ListView.builder(
          itemCount: songList.length,
          itemBuilder: (context, i) {
            return _buildRow(
              songList[i],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF54BEE6),
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
        _buildList(),
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
