import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/widgets/playlist_tile_grid.dart';

import '../enum/destination.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';

class PlaylistList extends StatefulWidget {
  @override
  State<PlaylistList> createState() => _PlaylistListState();

  final Destination destination;

  const PlaylistList({super.key, required this.destination});
}

class _PlaylistListState extends State<PlaylistList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Playlist>>(converter: (store) {
      return selectPlaylistByDestination(widget.destination);
    }, builder: (context, playlists) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: 170),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return PlaylistTileGrid(key: UniqueKey(), index: index, playlist: playlists[index]);
              },
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      );
    });
  }
}
