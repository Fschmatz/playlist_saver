import 'package:playlist_saver/class/tag.dart';

import '../db/tag_dao.dart';

class TagService {
  final tags = TagDao.instance;

  Future<List<Tag>> queryAllByPlaylistAndConvertToList(int idPlaylist) async {
    List<Map<String, dynamic>> resp = await tags.getTagsByIdTaskOrderName(idPlaylist);

    return resp.isNotEmpty ? resp.map((map) => Tag.fromMap(map)).toList() : [];
  }

  Future<List<Tag>> queryAllRowsByName() async {
    List<Map<String, dynamic>> resp = await tags.queryAllRowsByName();

    return resp.isNotEmpty ? resp.map((map) => Tag.fromMap(map)).toList() : [];
  }
}
