import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/class/spotify_metadata.dart';
import 'package:playlist_saver/enum/destination.dart';
import 'package:playlist_saver/enum/playlist_status.dart';
import 'package:playlist_saver/service/spotify_metadata_service.dart';

import '../class/backup.dart';
import '../db/playlist_dao.dart';
import 'widget_service.dart';

class PlaylistService {
  final dbPlaylist = PlaylistDao.instance;

  Future<List<Playlist>> queryByDestination(Destination destination) async {
    List<Map<String, dynamic>> resp = [];

    switch (destination) {
      case Destination.listen:
        resp = await dbPlaylist.queryAllRowsDescState(PlaylistStatus.listen.id);
        break;
      case Destination.archive:
        resp = await dbPlaylist.queryAllRowsByStateOrderByTitle(PlaylistStatus.archive.id);
        break;
      case Destination.favorites:
        resp = await dbPlaylist.queryAllRowsByStateOrderByTitle(PlaylistStatus.favorite.id);
        break;
      case Destination.downloads:
        resp = await dbPlaylist.queryAllRowsDownloadedOrderByTitle();
        break;
      case Destination.all:
        resp = await dbPlaylist.queryAllRowsOrderByTitle();
        break;
    }

    return resp.isNotEmpty ? resp.map((map) => Playlist.fromMap(map)).toList() : [];
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    await dbPlaylist.insert(playlist.toMap());
    await _updateWidget();
  }

  Future<void> updatePlaylist(Playlist playlist, PlaylistStatus oldState) async {
    await dbPlaylist.update(playlist.toMap());
    await _updateWidget();
  }

  Future<void> delete(Playlist playlist) async {
    await dbPlaylist.delete(playlist.idPlaylist!);
    await _updateWidget();
  }

  Future<void> changePlaylistState(Playlist playlist, PlaylistStatus newState) async {
    Playlist updatedPlaylist = playlist.copyWith(state: newState);
    await dbPlaylist.update(updatedPlaylist.toMap());
    await _updateWidget();
  }

  Future<void> insertBackupData(Backup backup) async {
    if (backup.playlists.isNotEmpty) {
      for (Map<String, dynamic> playlist in backup.playlists) {
        await dbPlaylist.insert(playlist);
      }
    }

    await _updateWidget();
  }

  Future<void> _updateWidget() async {
    final listenPlaylists = await dbPlaylist.queryAllRowsDescState(PlaylistStatus.listen.id);
    final playlists = listenPlaylists.map((map) => Playlist.fromMap(map)).toList();

    await WidgetService.updatePlaylistWidget(playlists);
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
      state: PlaylistStatus.listen,
      artist: artist,
      downloaded: downloaded ? 1 : 0,
      cover: compressedCover,
      newAlbum: newAlbum ? 1 : 0,
    );

    await insertPlaylist(playlist);
  }
}
