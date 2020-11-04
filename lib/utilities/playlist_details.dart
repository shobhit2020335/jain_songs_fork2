import 'package:flutter/material.dart';

class PlaylistDetails {
  String title;
  String subtitle;
  IconData leadIcon;
  Color color;
  //Active determines that whether the playlist is currently active or not.
  //Eg. Paryushan playlist is active only in paryushan.
  bool active;

  PlaylistDetails({
    this.active,
    this.title,
    this.subtitle,
    this.leadIcon,
    this.color: Colors.cyan,
  });
}
