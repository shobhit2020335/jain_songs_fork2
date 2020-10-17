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
  int _currentIndex = 0;
  bool showProgress = false;
  final _firestore = FirebaseFirestore.instance;
  Widget appBarTitle = Text(
    'Jain Songs',
  );
  Icon searchOrCrossIcon = Icon(Icons.search);
  Icon filterIcon = Icon(Icons.filter_list_alt);

  void getSongs() async {
    final songs = await _firestore.collection('songs').get();
    for (var song in songs.docs) {
      Map<String, dynamic> currentSong = song.data();
      String state = currentSong['aaa'];
      if (state != 'Invalid' && state != 'invalid') {
        songList.add(
          SongDetails(
              album: currentSong['album'],
              code: currentSong['code'],
              genre: currentSong['genre'],
              lyrics: currentSong['lyrics'],
              songNameEnglish: currentSong['songNameEnglish'],
              songNameHindi: currentSong['songNameHindi'],
              originalSong: currentSong['originalSong'],
              production: currentSong['production'],
              singer: currentSong['singer'],
              tirthankar: currentSong['tirthankar'],
              likes: currentSong['likes'],
              share: currentSong['share'],
              youTubeLink: currentSong['youTubeLink']),
        );
      }
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
        title: appBarTitle,
        centerTitle: true,
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                  icon: searchOrCrossIcon,
                  onPressed: () {
                    setState(() {
                      if (this.searchOrCrossIcon.icon == Icons.search) {
                        this.searchOrCrossIcon = Icon(Icons.close);
                        this.appBarTitle = TextField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            hintText: 'Search...',
                          ),
                        );
                      } else {
                        searchOrCrossIcon = Icon(Icons.search);
                        this.appBarTitle = Text('Jain Songs');
                      }
                    });
                  }),
              IconButton(icon: filterIcon, onPressed: null)
            ],
          ),
        ],
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
