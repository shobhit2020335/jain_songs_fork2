import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/buildList.dart';
import 'package:jain_songs/custom_widgets/build_playlistList.dart';
import 'package:jain_songs/form_page.dart';
import 'package:jain_songs/services/sharedPrefs.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/lists.dart';
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
  Icon filterIcon = Icon(
    Icons.filter_list_alt,
    color: Color(0xFF54BEE6),
  );

  void getSongs(String query) async {
    songList.clear();
    setState(() {
      showProgress = true;
    });
    QuerySnapshot songs;
    if (query == '') {
      songs = await _firestore.collection('songs').get();
    } else {
      songs = await _firestore
          .collection('songs')
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .get();
    }
    for (var song in songs.docs) {
      Map<String, dynamic> currentSong = song.data();
      String state = currentSong['aaa'];
      if (state != 'Invalid' && state != 'invalid') {
        SongDetails currentSongDetails = SongDetails(
            album: currentSong['album'],
            code: currentSong['code'],
            genre: currentSong['genre'],
            lyrics: currentSong['lyrics'],
            songNameEnglish: currentSong['songNameEnglish'],
            songNameHindi: currentSong['songNameHindi'],
            originalSong: currentSong['originalSong'],
            popularity: currentSong['popularity'],
            production: currentSong['production'],
            searchKeywords: currentSong['searchKeywords'],
            singer: currentSong['singer'],
            tirthankar: currentSong['tirthankar'],
            totalClicks: currentSong['totalClicks'],
            likes: currentSong['likes'],
            share: currentSong['share'],
            youTubeLink: currentSong['youTubeLink']);
        bool valueIsliked = await getisLiked(currentSong['code']);
        if (valueIsliked == null) {
          setisLiked(currentSong['code'], false);
          valueIsliked = false;
        }
        currentSongDetails.isLiked = valueIsliked;
        songList.add(
          currentSongDetails,
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
    getSongs('');
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
              _currentIndex == 0
                  ? IconButton(
                      //TODO: Insert focus in textField when search is clicked.
                      icon: searchOrCrossIcon,
                      onPressed: () {
                        setState(() {
                          if (this.searchOrCrossIcon.icon == Icons.search) {
                            this.searchOrCrossIcon = Icon(Icons.close);
                            this.appBarTitle = TextField(
                              onChanged: (value) {
                                getSongs(value);
                              },
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
                            getSongs('');
                          }
                        });
                      })
                  : Icon(null),
              _currentIndex == 0
                  ? IconButton(icon: filterIcon, onPressed: null)
                  : Icon(null),
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
            icon: Icon(FontAwesomeIcons.edit),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.archive),
            label: 'Playlists',
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
            if (index == 1) {
              appBarTitle = Text('');
            } else if (index == 2) {
              appBarTitle = Text('Playlists');
            } else if (index == 3) {
              appBarTitle = Text('Settings and More');
            } else {
              appBarTitle = Text('Jain Songs');
            }
          });
        },
      ),
      //IndexedStack use to store state of its children here used for bottom navigation's children.
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          BuildList(
            showProgress: showProgress,
          ),
          FormPage(),
          BuildPlaylistList(),
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
        ],
      ),
    );
  }
}
