import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/custom_widgets/song_card.dart';
import 'package:jain_songs/services/launch_otherApp.dart';
import 'package:jain_songs/utilities/song_details.dart';
import 'custom_widgets/constantWidgets.dart';

class SongPage extends StatefulWidget {
  final SongDetails currentSong;

  SongPage({this.currentSong});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    SongDetails currentSong = widget.currentSong;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentSong.songNameEnglish,
        ),
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                SongCard(
                  songNameEnglish: currentSong.songNameEnglish,
                  songNameHindi: currentSong.songNameHindi,
                  album: currentSong.album,
                  genre: currentSong.genre,
                  singer: currentSong.singer,
                  originalSong: currentSong.originalSong,
                  production: currentSong.production,
                  tirthankar: currentSong.tirthankar,
                  likes: currentSong.likes,
                  likesIcon: currentSong.isLiked == true
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  likesTap: () {
                    setState(() {
                      if (currentSong.isLiked == false) {
                        currentSong.likes++;
                        currentSong.isLiked = true;
                      } else {
                        currentSong.likes--;
                        currentSong.isLiked = false;
                      }
                    });
                  },
                  share: currentSong.share,
                  shareTap: () {
                    shareApp(currentSong.songNameHindi);
                    setState(() {
                      currentSong.share++;
                    });
                  },
                  youtubeTap: () {
                    String link = currentSong.youTubeLink;
                    if (link == null || link == '') {
                      showToast(context,
                          'Video URL is not available at this moment!');
                    } else {
                      //TODO: Add play Store link.
                      launchURL(context, link);
                    }
                  },
                  saveTap: () {
                    showToast(context, 'Saving lyrics Offline');
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Lyrics',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF18191A),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                LyricsWidget(
                  lyrics: currentSong.lyrics,
                ),
                Text(
                  '-----XXXXX-----',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF18191A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
