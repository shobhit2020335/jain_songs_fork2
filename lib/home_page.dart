import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'package:jain_songs/utilities/songs_list.dart';
import 'song_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TODO: Set the selectedindex to 2 when the user is offline.
  int _currentIndex = 0;

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

  Widget _buildSuggestions() {
    return ListView.builder(
        itemCount: songList.length,
        itemBuilder: (context, i) {
          return _buildRow(
            songList[i],
          );
        });
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
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.archive),
            title: Text('Library'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.wrench),
            title: Text('Settings'),
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
        _buildSuggestions(),
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
