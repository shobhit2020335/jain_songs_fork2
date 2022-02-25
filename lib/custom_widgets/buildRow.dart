import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/custom_widgets/constantWidgets.dart';
import 'package:jain_songs/services/database/database_controller.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/song_details.dart';
import '../song_page.dart';

class BuildRow extends StatefulWidget {
  final SongDetails? currentSong;
  final Color? color;
  final PlaylistDetails? playlist;
  final String? userSearched;
  final int positionInList;

  BuildRow(
    this.currentSong, {
    this.color: Colors.grey,
    this.playlist,
    this.userSearched,
    required this.positionInList,
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
      style: ListTileStyle.drawer,
      child: ListTile(
        title: Text(
          currentSong.songNameEnglish!,
          style: Theme.of(context).primaryTextTheme.bodyText1,
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
                currentSong.likes = currentSong.likes! - 1;
                currentSong.popularity = currentSong.popularity! - 1;
                setState(() {});
                DatabaseController()
                    .changeLikes(context, currentSong, -1)
                    .then((value) {
                  if (value == false) {
                    print('Error changing likes');
                    currentSong.isLiked = true;
                    currentSong.likes = currentSong.likes! + 1;
                    currentSong.popularity = currentSong.popularity! + 1;
                    ConstWidget.showSimpleToast(
                        context, 'Error Disliking song! Try again');
                  }
                  setState(() {});
                });
              } else {
                currentSong.isLiked = true;
                currentSong.likes = currentSong.likes! + 1;
                currentSong.popularity = currentSong.popularity! + 1;
                setState(() {});
                DatabaseController()
                    .changeLikes(context, currentSong, 1)
                    .then((value) {
                  if (value == false) {
                    print('Error changing likes');
                    currentSong.isLiked = false;
                    currentSong.likes = currentSong.likes! - 1;
                    currentSong.popularity = currentSong.popularity! - 1;
                    ConstWidget.showSimpleToast(
                        context, 'Error Liking song! Try again');
                  }
                  setState(() {});
                });
              }
            }),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return SongPage(
                currentSong: currentSong,
                playlist: widget.playlist,
                suggestionStreak: '$isFromPlaylist' + currentSong.code!,
                userSearched: widget.userSearched,
                postitionInList: widget.positionInList,
              );
            }),
          );
          setState(() {});
        },
      ),
    );
  }
}
