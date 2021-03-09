import 'package:flutter/material.dart';

class PlaylistDetails {
  String title;
  String subtitle;
  String playlistTag;
  IconData leadIcon;
  Color color;
  double iconSize;
  //Active determines that whether the playlist is currently active or not.
  //Eg. Paryushan playlist is active only in paryushan.
  bool active;

  PlaylistDetails({
    this.active,
    this.title,
    this.subtitle,
    this.playlistTag,
    this.leadIcon,
    this.iconSize: 30,
    this.color: Colors.cyan,
  });
}
