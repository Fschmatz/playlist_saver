import 'package:playlist_saver/class/playlist.dart';
import '../db/playlist_dao.dart';

class PlaylistService{

  final dbPlaylist = PlaylistDao.instance;

  Future<List<Playlist>> queryAllByStateAndConvertToList(int stateValue) async {
    var resp  = stateValue == 3 ?  await dbPlaylist.queryAllRowsDownloadedDesc() : await dbPlaylist.queryAllRowsDescState(stateValue);

    return resp.isNotEmpty ? resp.map((map) =>  Playlist.fromMap(map)).toList() : [];
  }

}