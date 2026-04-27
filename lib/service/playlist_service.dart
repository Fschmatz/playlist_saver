import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/class/spotify_metadata.dart';
import 'package:playlist_saver/enum/destination.dart';
import 'package:playlist_saver/service/spotify_metadata_service.dart';
import 'package:playlist_saver/service/store_service.dart';

import '../class/backup.dart';
import '../db/playlist_dao.dart';
import '../redux/selectors.dart';

class PlaylistService extends StoreService {
  final dbPlaylist = PlaylistDao.instance;

  Future<List<Playlist>> queryAllByStateAndConvertToList(int stateValue) async {
    List<Map<String, dynamic>> resp = [];

    switch (stateValue) {
      case 0:
        resp = await dbPlaylist.queryAllRowsDescState(stateValue);
        break;
      case 1:
      case 2:
        resp = await dbPlaylist.queryAllRowsByStateOrderByTitle(stateValue);
        break;
      case 3:
        resp = await dbPlaylist.queryAllRowsDownloadedOrderByTitle();
        break;
    }

    return resp.isNotEmpty ? resp.map((map) => Playlist.fromMap(map)).toList() : [];
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    await dbPlaylist.insert(playlist.toMap());

    loadPlaylists(Destination.listen);
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    await dbPlaylist.update(playlist.toMap());

    await loadPlaylists(selectCurrentDestination());
  }

  Future<void> delete(Playlist playlist) async {
    await dbPlaylist.delete(playlist.idPlaylist!);

    await loadPlaylists(selectCurrentDestination());
  }

  Future<void> changePlaylistState(Playlist playlist, int newState) async {
    int oldState = playlist.state;

    Playlist updatedPlaylist = playlist.copyWith(state: newState);
    await dbPlaylist.update(updatedPlaylist.toMap());

    await loadPlaylistsOnChangeState(oldState, newState);
  }

  Future<void> insertBackupData(Backup backup) async {
    if (backup.playlists.isNotEmpty) {
      for (Map<String, dynamic> playlist in backup.playlists) {
        await dbPlaylist.insert(playlist);
      }
    }

    await loadPlaylists(selectCurrentDestination());
  }

  Future<void> saveNewPlaylistFromMetadata({
    required SpotifyMetadata? metadata,
    required String title,
    required String artist,
    required String link,
    required bool downloaded,
    required bool newAlbum,
  }) async {
    Uint8List? compressedCover;

    if (metadata != null) {
      http.Response response = await http.get(Uri.parse(metadata.imageUrl));
      compressedCover = await SpotifyMetadataService().compressCoverImage(response.bodyBytes);
    }

    Playlist playlist = Playlist(
      link: link,
      title: title,
      state: 0,
      artist: artist,
      downloaded: downloaded ? 1 : 0,
      cover: compressedCover,
      newAlbum: newAlbum ? 1 : 0,
    );

    await insertPlaylist(playlist);
  }
}
