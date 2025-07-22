import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/enum/destination.dart';

import '../main.dart';

List<Playlist> selectPlaylistByDestination(Destination destination) {
  switch (destination) {
    case Destination.listen:
      return store.state.listListen;
    case Destination.archive:
      return store.state.listArchive;
    case Destination.favorites:
      return store.state.listFavorites;
    case Destination.downloads:
      return store.state.listDownloads;
  }
}

Destination selectCurrentDestination() => store.state.currentDestination;
