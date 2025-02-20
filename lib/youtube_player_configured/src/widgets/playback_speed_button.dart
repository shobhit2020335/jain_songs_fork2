// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../enums/playback_rate.dart';
import '../utils/youtube_player_controller.dart';

/// A widget to display playback speed changing button.
class PlaybackSpeedButton extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Defines icon for the button.
  final Widget icon = Icon(
    Icons.ac_unit,
    color: Colors.transparent,
  );

  /// Creates [PlaybackSpeedButton] widget.
  PlaybackSpeedButton({
    this.controller,
  });

  @override
  State<PlaybackSpeedButton> createState() => _PlaybackSpeedButtonState();
}

class _PlaybackSpeedButtonState extends State<PlaybackSpeedButton> {
  late YoutubePlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller == null) {
      assert(
        widget.controller != null,
        '\n\nNo controller could be found in the provided context.\n\n'
        'Try passing the controller explicitly.',
      );
      _controller = widget.controller!;
    } else {
      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      onSelected: _controller.setPlaybackRate,
      tooltip: 'PlayBack Rate',
      itemBuilder: (context) => [
        _popUpItem('2.0x', PlaybackRate.twice),
        _popUpItem('1.75x', PlaybackRate.oneAndAThreeQuarter),
        _popUpItem('1.5x', PlaybackRate.oneAndAHalf),
        _popUpItem('1.25x', PlaybackRate.oneAndAQuarter),
        _popUpItem('Normal', PlaybackRate.normal),
        _popUpItem('0.75x', PlaybackRate.threeQuarter),
        _popUpItem('0.5x', PlaybackRate.half),
        _popUpItem('0.25x', PlaybackRate.quarter),
      ],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
        child: widget.icon,
      ),
    );
  }

  PopupMenuEntry<double> _popUpItem(String text, double rate) {
    return CheckedPopupMenuItem(
      checked: _controller.value.playbackRate == rate,
      value: rate,
      child: Text(text),
    );
  }
}
