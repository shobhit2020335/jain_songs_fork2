import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/song_details.dart';

List<SongDetails> songList = [];

List<SongDetails> listToShow = [];

void addElementsToList(Color colorRowIcon) {
  listToShow.clear();
  if (colorRowIcon == Colors.grey) {
    for (int i = 0; i < songList.length; i++) {
      listToShow.add(songList[i]);
    }
  } else {
    for (int i = 0; i < songList.length; i++) {
      if (songList[i].isLiked == true) {
        listToShow.add(songList[i]);
      }
    }
  }
}

//TODO: Edit list for different playlist.
List<PlaylistDetails> playlistList = [
  PlaylistDetails(
    active: true,
    title: 'Favourites',
    subtitle: 'No liked Songs',
    leadIcon: FontAwesomeIcons.gratipay,
    color: Colors.pink,
  ),
  PlaylistDetails(
    active: true,
    title: 'Latest Releases',
    subtitle: 'New song lyrics',
    leadIcon: FontAwesomeIcons.calendarPlus,
    color: Colors.green,
  ),
  PlaylistDetails(
    active: true,
    title: 'Popular',
    subtitle: 'All time hits',
    leadIcon: FontAwesomeIcons.fire,
    color: Colors.amber,
  ),
  PlaylistDetails(
    active: true,
    title: 'Bhakti Special',
    subtitle: 'Playlist for Bhakti',
    leadIcon: Icons.ac_unit,
    color: Colors.blueGrey,
  ),
  PlaylistDetails(
    active: true,
    title: 'Parshwanath',
    subtitle: 'Parasnath Bhajans',
    leadIcon: FontAwesomeIcons.prayingHands,
    color: Color(0xFF54BEE6),
  ),
  PlaylistDetails(
    active: false,
    title: 'Paryushan Special',
    subtitle: 'Mahaparv Paryushan Bhajans',
    leadIcon: FontAwesomeIcons.prayingHands,
    color: Color(0xFF54BEE6),
  ),
];
