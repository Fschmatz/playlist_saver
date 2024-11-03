import 'dart:typed_data';
import 'package:playlist_saver/class/playlist.dart';
import '../db/playlist_dao.dart';

class PlaylistService {
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

  Future<void> insertPlaylist(Uint8List? compressedCover, String link, String title, String artist, bool downloaded, bool newAlbum) async {
    Map<String, dynamic> row = {
      PlaylistDao.columnLink: link,
      PlaylistDao.columnTitle: title,
      PlaylistDao.columnState: 0,
      PlaylistDao.columnArtist: artist,
      PlaylistDao.columnDownloaded: downloaded ? 1 : 0,
      PlaylistDao.columnCover: compressedCover ?? compressedCover,
      PlaylistDao.columnNewAlbum: newAlbum ? 1 : 0,
    };

    await dbPlaylist.insert(row);
  }

  Future<void> updatePlaylist(int idPlaylist, String link, String title, String artist, bool downloaded, bool newAlbum) async {
    Map<String, dynamic> row = {
      PlaylistDao.columnIdPlaylist: idPlaylist,
      PlaylistDao.columnLink: link,
      PlaylistDao.columnTitle: title,
      PlaylistDao.columnDownloaded: downloaded ? 1 : 0,
      PlaylistDao.columnArtist: artist,
      PlaylistDao.columnNewAlbum: newAlbum ? 1 : 0,
    };

    await dbPlaylist.update(row);
  }
}
