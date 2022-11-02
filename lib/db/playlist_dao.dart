import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class PlaylistDao {

  static const _databaseName = "PlaylistSaver.db";
  static const _databaseVersion = 1;

  static const table = 'playlists';
  static const columnIdPlaylist = 'id_playlist';
  static const columnLink = 'link';
  static const columnTitle = 'title';
  static const columnState = 'state';
  static const columnArtist = 'artist';
  static const columnCover = 'cover';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  PlaylistDao._privateConstructor();
  static final PlaylistDao instance = PlaylistDao._privateConstructor();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDesc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table ORDER BY id_playlist DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDescState(int state) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnState = $state ORDER BY id_playlist DESC');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnIdPlaylist];
    return await db.update(table, row, where: '$columnIdPlaylist = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnIdPlaylist = ?', whereArgs: [id]);
  }

}
