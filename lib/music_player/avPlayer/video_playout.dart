import 'package:flutter/material.dart';
import 'package:flutter_playout/multiaudio/MultiAudioSupport.dart';
import 'package:flutter_playout/player_observer.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout/video.dart';
import 'package:jain_songs/utilities/song_details.dart';

class VideoPlayout extends StatefulWidget {
  final PlayerState desiredState;
  final bool showPlayerControls;
  final bool autoPlay;
  final bool loop;
  final SongDetails song;

  const VideoPlayout({
    Key? key,
    required this.song,
    this.desiredState: PlayerState.PLAYING,
    this.showPlayerControls: true,
    this.autoPlay: true,
    this.loop: false,
  }) : super(key: key);

  @override
  _VideoPlayoutState createState() => _VideoPlayoutState();
}

class _VideoPlayoutState extends State<VideoPlayout>
    with PlayerObserver, MultiAudioSupport {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Video(
              autoPlay: widget.autoPlay,
              showControls: widget.showPlayerControls,
              title: widget.song.songNameEnglish,
              subtitle: widget.song.songInfo,
              isLiveStream: false,
              position: 0,
              url: widget.song.youTubeLink,
              onViewCreated: _onViewCreated,
              desiredState: widget.desiredState,
              preferredTextLanguage: 'en',
              loop: widget.loop,
            ),
          ),
        ],
      ),
    );
  }

  void _onViewCreated(int viewId) {
    listenForVideoPlayerEvents(viewId);
    enableMultiAudioSupport(viewId);
  }

  @override
  void onPlay() {
    super.onPlay();
  }

  @override
  void onPause() {
    super.onPause();
  }

  @override
  void onComplete() {
    super.onComplete();
  }

  @override
  void onTime(int? position) {
    super.onTime(position);
  }

  @override
  void onSeek(int? position, double offset) {
    super.onSeek(position, offset);
  }

  @override
  void onDuration(int? duration) {
    super.onDuration(duration);
  }

  @override
  void onError(String? error) {
    super.onError(error);
    print('error mili: $error');
  }
}
