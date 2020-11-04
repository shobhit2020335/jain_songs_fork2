import 'package:flutter/material.dart';
import 'package:jain_songs/playlist_page.dart';
import 'package:jain_songs/utilities/playlist_details.dart';

//TODO: Bug: click on any item in the list opens favourites page.

class BuildPlaylistRow extends StatelessWidget {
  final PlaylistDetails playlistDetails;

  BuildPlaylistRow({this.playlistDetails});

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: ListTile(
        leading: Icon(
          playlistDetails.leadIcon,
          color: playlistDetails.color,
          size: 35,
        ),
        title: Text(
          playlistDetails.title,
          style: TextStyle(color: Color(0xFF212323)),
        ),
        subtitle: Text(
          playlistDetails.subtitle,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistPage(playlistDetails),
            ),
          );
        },
      ),
    );
  }
}
