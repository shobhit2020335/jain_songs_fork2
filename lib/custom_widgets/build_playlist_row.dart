import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jain_songs/utilities/playlist_details.dart';

class BuildPlaylistRow extends StatelessWidget {
  final PlaylistDetails? playlistDetails;

  const BuildPlaylistRow(this.playlistDetails, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: ListTile(
        leading: Icon(
          playlistDetails!.leadIcon,
          color: playlistDetails!.color,
          size: playlistDetails!.iconSize,
        ),
        title: Text(
          playlistDetails!.title,
          style: Theme.of(context).primaryTextTheme.bodyLarge,
        ),
        subtitle: Text(
          playlistDetails!.subtitle,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
        ),
        onTap: () {
          context.go('/v2/allplaylist/${playlistDetails!.title}',
              extra: playlistDetails);
        },
      ),
    );
  }
}
