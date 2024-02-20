import 'package:jain_songs/services/suggester.dart';
import 'package:jain_songs/utilities/lists.dart';
import 'package:jain_songs/utilities/playlist_details.dart';
import 'package:jain_songs/utilities/song_details.dart';

class SongDetailsObject {
  final String? codeFromDynamicLink;
  final SongDetails? currentSong;
  final PlaylistDetails? playlist;
  final Suggester? suggester;
  final String suggestionStreak;
  //Used in user behaviour capture
  final String? userSearched;
  //Dont use it other than user behaviour. Or undertand user behaviour and then use.
  final int postitionInList;

  SongDetailsObject({
    this.currentSong,
    this.codeFromDynamicLink,
    this.playlist,
    this.suggester,
    required this.suggestionStreak,
    this.userSearched,
    required this.postitionInList,
  });
}
