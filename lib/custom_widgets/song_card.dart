import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget textBold20(String text) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );
}

Widget songFunctionIcon(
    {@required IconData icon, String text, Function onPress}) {
  return Column(
    children: [
      GestureDetector(
        // onLongPress: onPress,
        onTap: onPress,
        child: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
      ),
      SizedBox(
        height: 8,
      ),
      GestureDetector(
        onTap: onPress,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

Widget miniCard(
    {int likes,
    int share,
    Function likesTap,
    IconData likesIcon,
    Function youtubeTap,
    Function saveTap,
    Function shareTap}) {
  return Card(
    margin: EdgeInsets.only(bottom: 0),
    color: Color(0xFF7DCFEF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          songFunctionIcon(
            icon: likesIcon,
            text: likes.toString(),
            onPress: likesTap,
          ),
          SizedBox(
            width: 40,
          ),
          songFunctionIcon(
            icon: FontAwesomeIcons.youtube,
            text: 'Listen',
            onPress: youtubeTap,
          ),
          SizedBox(
            width: 40,
          ),
          songFunctionIcon(
            icon: FontAwesomeIcons.download,
            text: 'Save',
            onPress: saveTap,
          ),
          SizedBox(
            width: 40,
          ),
          songFunctionIcon(
            icon: FontAwesomeIcons.share,
            text: share.toString(),
            onPress: shareTap,
          ),
        ],
      ),
    ),
  );
}

// ignore: must_be_immutable
class SongCard extends StatelessWidget {
  final String songNameEnglish;
  final String songNameHindi;
  String singer;
  String album;
  String genre;
  String tirthankar;
  String production;
  String originalSong;
  int likes;
  int share;
  Function likesTap;
  Function youtubeTap;
  Function saveTap;
  Function shareTap;
  IconData likesIcon;

  SongCard(
      {@required this.songNameEnglish,
      @required this.songNameHindi,
      this.album,
      this.genre: 'Bhakti',
      this.originalSong,
      this.production,
      this.singer,
      this.tirthankar,
      this.likes: 0,
      this.likesIcon,
      this.share: 0,
      this.likesTap,
      this.saveTap,
      this.shareTap,
      this.youtubeTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      //Background Color of card.
      color: Color(0xFF54BEE6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              //Changes color of arrow when tile is not open.
              unselectedWidgetColor: Colors.white,
            ),
            child: ExpansionTile(
              title: textBold20(songNameHindi),
              childrenPadding: EdgeInsets.only(
                bottom: 10,
              ),
              children: [
                if (tirthankar != null && tirthankar.length > 0)
                  Text('Tirthankar: $tirthankar'),
                if (singer != null && singer.length > 0)
                  Text('Singer: $singer'),
                if (genre != null && singer.length > 0) Text('Genre: $genre'),
                if (production != null && production.length > 0)
                  Text('Production: $production'),
                if (originalSong != null && originalSong.length > 0)
                  Text('Original Song: $originalSong'),
                if (album != null && album.length > 0) Text('Movie: $album'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: miniCard(
              likes: likes,
              likesTap: likesTap,
              likesIcon: likesIcon,
              youtubeTap: youtubeTap,
              saveTap: saveTap,
              share: share,
              shareTap: shareTap,
            ),
          ),
        ],
      ),
    );
  }
}
