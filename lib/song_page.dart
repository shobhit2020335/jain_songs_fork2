import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/lyrics_widget.dart';
import 'package:jain_songs/custom_widgets/song_card.dart';
import 'package:jain_songs/utilities/song_details.dart';

class SongPage extends StatefulWidget {
  SongDetails currentSong;

  SongPage({this.currentSong});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  // IconData likesIcon = FontAwesomeIcons.heart;

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'HIDE', onPressed: scaffold.hideCurrentSnackBar),
    );
    scaffold.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //TODO: Can underline the text, later.
          widget.currentSong.songNameEnglish,
        ),
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                SongCard(
                  songName_English: widget.currentSong.songNameEnglish,
                  songName_Hindi: widget.currentSong.songNameHindi,
                  singer: widget.currentSong.singer,
                  production: widget.currentSong.production,
                  tirthankar: widget.currentSong.tirthankar,
                  likes: widget.currentSong.likes,
                  likesIcon: widget.currentSong.isLiked == true
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  likesTap: () {
                    setState(() {
                      if (widget.currentSong.isLiked == false) {
                        widget.currentSong.likes++;
                        widget.currentSong.isLiked = true;
                      } else {
                        widget.currentSong.likes--;
                        widget.currentSong.isLiked = false;
                      }
                    });
                  },
                  share: widget.currentSong.share,
                  shareTap: () {
                    setState(() {
                      widget.currentSong.share++;
                    });
                  },
                  youtubeTap: () {
                    _showToast(
                        context, 'Video URL is not available at this moment!');
                  },
                  saveTap: () {
                    _showToast(context, 'Saving lyrics Offline');
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
                  lyrics: widget.currentSong.lyrics,
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
