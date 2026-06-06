import 'package:flutter/material.dart';
import 'package:playlist_saver/widgets/playlist_tile_grid.dart';

import '../enum/destination.dart';
import '../redux/app_state.dart';
import '../redux/selectors.dart';
import '../util/app_constants.dart';

class PlaylistList extends StatelessWidget {
  final Destination destination;

  const PlaylistList({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final playlists = context.select((state) => selectPlaylistByDestination(state, destination));
    final showAlbumInfo = context.select((state) => selectParameterValueByKeyAsBoolean(state, AppConstants.showAlbumInfoAppParameter));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
      ),
    );
  }
}
