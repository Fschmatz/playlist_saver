import 'package:playlist_saver/class/playlist.dart';

import '../enum/destination.dart';
import '../service/playlist_service.dart';
import 'app_action.dart';
import 'app_state.dart';

class LoadPlaylistsAction extends AppAction {
  final Destination destination;
  final bool forceReload;

  LoadPlaylistsAction(this.destination, {this.forceReload = false});

  @override
  Future<AppState> reduce() async {
    List<Playlist> playlists;

    switch (destination) {
      case Destination.listen:
        playlists =
            state.listListen.isEmpty || forceReload ? await PlaylistService().queryAllByStateAndConvertToList(destination.id) : state.listListen;
        return state.copyWith(listListen: playlists);
      case Destination.archive:
        playlists =
            state.listArchive.isEmpty || forceReload ? await PlaylistService().queryAllByStateAndConvertToList(destination.id) : state.listArchive;
        return state.copyWith(listArchive: playlists);
      case Destination.favorites:
        playlists = state.listFavorites.isEmpty || forceReload
            ? await PlaylistService().queryAllByStateAndConvertToList(destination.id)
            : state.listFavorites;
        return state.copyWith(listFavorites: playlists);
      case Destination.downloads:
        playlists = state.listDownloads.isEmpty || forceReload
            ? await PlaylistService().queryAllByStateAndConvertToList(destination.id)
            : state.listDownloads;
        return state.copyWith(listDownloads: playlists);
    }
  }
}

class ChangeDestinationAction extends AppAction {
  final Destination destination;

  ChangeDestinationAction(this.destination);

  @override
  Future<AppState> reduce() async {
    return state.copyWith(currentDestination: destination);
  }
}
