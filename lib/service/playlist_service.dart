import 'package:playlist_saver/class/playlist.dart';
import '../db/playlist_dao.dart';

class PlaylistService{

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

    return resp.isNotEmpty ? resp.map((map) =>  Playlist.fromMap(map)).toList() : [];
  }

}