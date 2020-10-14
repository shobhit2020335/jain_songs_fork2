import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/utilities/song_details.dart';
import '../song_page.dart';

class BuildRow extends StatefulWidget {
  final SongDetails currentSong;

  BuildRow({@required this.currentSong});

  @override
  _BuildRowState createState() => _BuildRowState();
}

class _BuildRowState extends State<BuildRow> {
  @override
  Widget build(BuildContext context) {
    SongDetails currentSong = widget.currentSong;
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
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongPage(currentSong: currentSong),
            ),
          );
          setState(() {});
        },
      ),
    );
  }
}
