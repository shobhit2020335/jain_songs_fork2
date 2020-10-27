import 'package:flutter/material.dart';
import 'package:jain_songs/utilities/playlist_details.dart';

//TODO: create UI for playlist list.

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
          color: Colors.black,
        ),
        title: Text(
          playlistDetails.title,
          style: TextStyle(color: Color(0xFF212323)),
        ),
        subtitle: Text(
          playlistDetails.subtitle,
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
