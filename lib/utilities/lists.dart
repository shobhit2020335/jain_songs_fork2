import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/utilities/playlist_details.dart';

List songList = [];

//TODO: Edit list for different playlist.
List<PlaylistDetails> playlistList = [
  PlaylistDetails(
    active: true,
    title: 'Favourites',
    subtitle: 'No liked Songs',
    leadIcon: Icons.ac_unit,
  ),
  PlaylistDetails(
    active: true,
    title: 'Latest Releases',
    subtitle: 'New song lyrics',
    leadIcon: Icons.ac_unit,
  ),
  PlaylistDetails(
    active: true,
    title: 'Popular',
    subtitle: 'All time hits',
    leadIcon: Icons.ac_unit,
  ),
  PlaylistDetails(
    active: true,
    title: 'Bhakti Special',
    subtitle: 'Playlist for Bhakti',
    leadIcon: Icons.ac_unit,
  ),
  PlaylistDetails(
    active: true,
    title: 'Parshwanath',
    subtitle: 'Parasnath Bhajans',
    leadIcon: Icons.access_alarm_outlined,
  ),
  PlaylistDetails(
    active: false,
    title: 'Paryushan Special',
    subtitle: 'Mahaparv Paryushan Bhajans',
    leadIcon: Icons.ac_unit,
  ),
];
