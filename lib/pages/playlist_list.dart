import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/widgets/playlist_tile_grid.dart';

import '../enum/destination.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';
import '../util/app_constants.dart';

class PlaylistList extends StatefulWidget {
  @override
  State<PlaylistList> createState() => _PlaylistListState();

  final Destination destination;

  const PlaylistList({super.key, required this.destination});
}

class _PlaylistListState extends State<PlaylistList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, (List<Playlist>, bool)>(converter: (store) {
      return (selectPlaylistByDestination(widget.destination), selectParameterValueByKeyAsBoolean(AppConstants.showAlbumInfoAppParameter));
    }, builder: (context, viewData) {
      final (playlists, showAlbumInfo) = viewData;

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: showAlbumInfo ? 0.74 : 1,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];

              return PlaylistTileGrid(
                key: ValueKey(playlist.idPlaylist),
                index: index,
                playlist: playlist,
                showAlbumInfo: showAlbumInfo,
              );
            },
          ),
          const SizedBox(height: 50),
        ],
      );
    });
  }
}
