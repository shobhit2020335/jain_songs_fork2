import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/services/database/database_controlller.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/song_details.dart';
import '../song_page.dart';

class BuildRow extends StatefulWidget {
  final SongDetails? currentSong;
  final Color? color;
  final PlaylistDetails? playlist;

  BuildRow(
    this.currentSong, {
    this.color: Colors.grey,
    this.playlist,
  });

  @override
  _BuildRowState createState() => _BuildRowState();
}

class _BuildRowState extends State<BuildRow> {
  @override
  Widget build(BuildContext context) {
    //This is for storing suggester streak data in firestore.
    String isFromPlaylist = widget.playlist != null ? '1' : '0';
    SongDetails currentSong = widget.currentSong!;

    return ListTileTheme(
      selectedColor: Colors.blue[300],
      style: ListTileStyle.drawer,
      child: ListTile(
        title: Text(
          currentSong.songNameEnglish!,
          style: TextStyle(color: Color(0xFF212323)),
        ),
        subtitle: Text(
          currentSong.songInfo,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            currentSong.isLiked == true
                ? FontAwesomeIcons.solidHeart
                : FontAwesomeIcons.heart,
            color: widget.color,
          ),
          onPressed: () async {
            if (currentSong.isLiked == true) {
              currentSong.isLiked = false;
              setState(() {});
              DatabaseController().changeLikes(context, currentSong, -1);
            } else {
              currentSong.isLiked = true;
              setState(() {});
              DatabaseController().changeLikes(context, currentSong, 1);
            }
            setState(() {});
          },
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return SongPage(
                currentSong: currentSong,
                playlist: widget.playlist,
                suggestionStreak: '$isFromPlaylist' + currentSong.code!,
              );
            }),
          );
          setState(() {});
        },
      ),
    );
  }
}
