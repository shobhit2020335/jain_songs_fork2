import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'constantWidgets.dart';

Widget miniCard(
    {int likes,
    int share,
    Function likesTap,
    IconData likesIcon,
    Function youtubeTap,
    Function languageTap,
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
            icon: FontAwesomeIcons.language,
            text: 'Language',
            onPress: languageTap,
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
  final SongDetails currentSong;
  Function likesTap;
  Function youtubeTap;
  Function languageTap;
  Function shareTap;
  IconData likesIcon;

  SongCard(
      {@required this.currentSong,
      this.likesIcon,
      this.likesTap,
      this.languageTap,
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
              title: textBold20(currentSong.songNameHindi),
              childrenPadding: EdgeInsets.only(
                bottom: 10,
              ),
              children: [
                if (currentSong.tirthankar != null &&
                    currentSong.tirthankar.length > 0)
                  Text('Tirthankar: ${currentSong.tirthankar}'),
                if (currentSong.genre != null && currentSong.genre.length > 0)
                  Text('Genre: ${currentSong.genre}'),
                if (currentSong.singer != null && currentSong.singer.length > 0)
                  Text('Singer: ${currentSong.singer}'),
                if (currentSong.album != null && currentSong.album.length > 0)
                  Text('Album: ${currentSong.album}'),
                if (currentSong.originalSong != null &&
                    currentSong.originalSong.length > 0)
                  Text('Original Song: ${currentSong.originalSong}'),
                if (currentSong.language != null &&
                    currentSong.language.length > 0)
                  Text('Language: ${currentSong.language}'),
                if (currentSong.production != null &&
                    currentSong.production.length > 0)
                  Text('Production: ${currentSong.production}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: miniCard(
              likes: currentSong.likes,
              likesTap: likesTap,
              likesIcon: likesIcon,
              youtubeTap: youtubeTap,
              languageTap: languageTap,
              share: currentSong.share,
              shareTap: shareTap,
            ),
          ),
        ],
      ),
    );
  }
}
