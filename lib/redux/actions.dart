import 'package:playlist_saver/class/playlist.dart';

import '../enum/destination.dart';
import '../service/playlist_service.dart';
import 'app_action.dart';
import 'app_state.dart';

class LoadPlaylistsAction extends AppAction {
  final Destination destination;

  LoadPlaylistsAction(this.destination);

  @override
  Future<AppState> reduce() async {
    List<Playlist> playlists;

    switch (destination) {
      case Destination.listen:
        playlists = await PlaylistService().queryAllByStateAndConvertToList(destination.id);
        return state.copyWith(listListen: playlists);
      case Destination.archive:
        playlists = await PlaylistService().queryAllByStateAndConvertToList(destination.id);
        return state.copyWith(listArchive: playlists);
      case Destination.favorites:
        playlists = await PlaylistService().queryAllByStateAndConvertToList(destination.id);
        return state.copyWith(listFavorites: playlists);
      case Destination.downloads:
        playlists = await PlaylistService().queryAllByStateAndConvertToList(destination.id);
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
