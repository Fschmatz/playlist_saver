import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:playlist_saver/service/app_parameter_service.dart';

import '../class/app_parameter.dart';
import '../class/backup.dart';
import '../class/playlist.dart';
import '../class/spotify_metadata.dart';
import '../enum/destination.dart';
import '../enum/playlist_status.dart';
import '../service/playlist_service.dart';
import '../service/spotify_metadata_service.dart';
import 'app_state.dart';
import 'helper/app_action.dart';

class LoadAppParametersAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<AppParameter> parameters = await AppParameterService().getAll();

    return state.copyWith(appParameters: parameters);
  }
}

class SaveAppParameterAction extends AppAction {
  final AppParameter appParameter;

  SaveAppParameterAction(this.appParameter);

  @override
  Future<AppState> reduce() async {
    await AppParameterService().saveParameter(appParameter);
    List<AppParameter> parameters = await AppParameterService().getAll();

    return state.copyWith(appParameters: parameters);
  }
}

class LoadPlaylistsAction extends AppAction {
  final Destination destination;
  final bool forceReload;

  LoadPlaylistsAction(this.destination, {this.forceReload = false});

  @override
  Future<AppState> reduce() async {
    final cached = switch (destination) {
      Destination.listen => state.listListen,
      Destination.archive => state.listArchive,
      Destination.favorites => state.listFavorites,
      Destination.downloads => state.listDownloads,
      Destination.all => state.listAll,
    };

    final playlists = (cached.isEmpty || forceReload) ? await PlaylistService().queryByDestination(destination) : cached;

    return switch (destination) {
      Destination.listen => state.copyWith(listListen: playlists, currentDestination: destination),
      Destination.archive => state.copyWith(listArchive: playlists, currentDestination: destination),
      Destination.favorites => state.copyWith(listFavorites: playlists, currentDestination: destination),
      Destination.downloads => state.copyWith(listDownloads: playlists, currentDestination: destination),
      Destination.all => state.copyWith(listAll: playlists, currentDestination: destination),
    };
  }
}

class ChangeDestinationAction extends AppAction {
  final Destination destination;

  ChangeDestinationAction(this.destination);

  @override
  AppState reduce() {
    return state.copyWith(currentDestination: destination);
  }
}

class ReloadCurrentDestinationAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    final destination = state.currentDestination;
    final playlists = await PlaylistService().queryByDestination(destination);

    return switch (destination) {
      Destination.listen => state.copyWith(listListen: playlists),
      Destination.archive => state.copyWith(listArchive: playlists),
      Destination.favorites => state.copyWith(listFavorites: playlists),
      Destination.downloads => state.copyWith(listDownloads: playlists),
      Destination.all => state.copyWith(listAll: playlists),
    };
  }
}

class ReloadDestinationsAction extends AppAction {
  final List<Destination> destinations;

  ReloadDestinationsAction(this.destinations);

  @override
  Future<AppState> reduce() async {
    AppState newState = state;

    for (final dest in destinations) {
      final playlists = await PlaylistService().queryByDestination(dest);
      newState = switch (dest) {
        Destination.listen => newState.copyWith(listListen: playlists),
        Destination.archive => newState.copyWith(listArchive: playlists),
        Destination.favorites => newState.copyWith(listFavorites: playlists),
        Destination.downloads => newState.copyWith(listDownloads: playlists),
        Destination.all => newState.copyWith(listAll: playlists),
      };
    }

    return newState;
  }
}

class AddPlaylistAction extends AppAction {
  final SpotifyMetadata? metadata;
  final String title;
  final String artist;
  final String link;
  final bool downloaded;
  final bool newAlbum;

  AddPlaylistAction({
    required this.metadata,
    required this.title,
    required this.artist,
    required this.link,
    required this.downloaded,
    required this.newAlbum,
  });

  @override
  Future<AppState> reduce() async {
    Uint8List? compressedCover;

    if (metadata != null) {
      http.Response response = await http.get(Uri.parse(metadata!.imageUrl));
      compressedCover = await SpotifyMetadataService().compressCoverImage(response.bodyBytes);
    }

    Playlist playlist = Playlist(
      link: link,
      title: title,
      state: PlaylistStatus.listen,
      artist: artist,
      downloaded: downloaded ? 1 : 0,
      cover: compressedCover,
      newAlbum: newAlbum ? 1 : 0,
    );

    await PlaylistService().insertPlaylist(playlist);

    final playlists = await PlaylistService().queryByDestination(Destination.listen);
    return state.copyWith(listListen: playlists);
  }
}

class UpdatePlaylistAction extends AppAction {
  final Playlist playlist;
  final PlaylistStatus oldState;

  UpdatePlaylistAction(this.playlist, this.oldState);

  @override
  Future<AppState> reduce() async {
    await PlaylistService().updatePlaylist(playlist, oldState);

    List<Destination> toReload = [];
    if (playlist.state != oldState) {
      toReload.add(_destinationFromStatus(oldState));
      toReload.add(_destinationFromStatus(playlist.state));
    } else {
      toReload.add(_destinationFromStatus(playlist.state));
    }

    AppState newState = state;
    for (final dest in toReload) {
      final playlists = await PlaylistService().queryByDestination(dest);
      newState = switch (dest) {
        Destination.listen => newState.copyWith(listListen: playlists),
        Destination.archive => newState.copyWith(listArchive: playlists),
        Destination.favorites => newState.copyWith(listFavorites: playlists),
        Destination.downloads => newState.copyWith(listDownloads: playlists),
        Destination.all => newState.copyWith(listAll: playlists),
      };
    }

    return newState;
  }

  Destination _destinationFromStatus(PlaylistStatus status) {
    return switch (status) {
      PlaylistStatus.listen => Destination.listen,
      PlaylistStatus.archive => Destination.archive,
      PlaylistStatus.favorite => Destination.favorites,
    };
  }
}

class DeletePlaylistAction extends AppAction {
  final Playlist playlist;

  DeletePlaylistAction(this.playlist);

  @override
  Future<AppState> reduce() async {
    await PlaylistService().delete(playlist);
    final destination = _destinationFromStatus(playlist.state);
    final playlists = await PlaylistService().queryByDestination(destination);

    return switch (destination) {
      Destination.listen => state.copyWith(listListen: playlists),
      Destination.archive => state.copyWith(listArchive: playlists),
      Destination.favorites => state.copyWith(listFavorites: playlists),
      Destination.downloads => state.copyWith(listDownloads: playlists),
      Destination.all => state.copyWith(listAll: playlists),
    };
  }

  Destination _destinationFromStatus(PlaylistStatus status) {
    return switch (status) {
      PlaylistStatus.listen => Destination.listen,
      PlaylistStatus.archive => Destination.archive,
      PlaylistStatus.favorite => Destination.favorites,
    };
  }
}

class RestoreBackupAction extends AppAction {
  final Backup backup;

  RestoreBackupAction(this.backup);

  @override
  Future<AppState> reduce() async {
    await PlaylistService().insertBackupData(backup);
    await AppParameterService().insertParametersFromRestoreBackup(backup.parameters);

    final parameters = await AppParameterService().getAll();
    final listenPlaylists = await PlaylistService().queryByDestination(Destination.listen);

    return state.copyWith(
      appParameters: parameters,
      listListen: listenPlaylists,
      listArchive: [],
      listFavorites: [],
      listDownloads: [],
      listAll: [],
      currentDestination: Destination.listen,
    );
  }
}
