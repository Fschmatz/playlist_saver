import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class PlaylistDao {
  static const table = DatabaseHelper.tablePlaylists;
  static const columnIdPlaylist = DatabaseHelper.columnIdPlaylist;
  static const columnLink = DatabaseHelper.columnLink;
  static const columnTitle = DatabaseHelper.columnTitle;
  static const columnState = DatabaseHelper.columnState;
  static const columnArtist = DatabaseHelper.columnArtist;
  static const columnDownloaded = DatabaseHelper.columnDownloaded;
  static const columnCover = DatabaseHelper.columnCover;
  static const columnNewAlbum = DatabaseHelper.columnNewAlbum;

  PlaylistDao._privateConstructor();

  static final PlaylistDao instance = PlaylistDao._privateConstructor();

  Future<Database> get database async => await DatabaseHelper.instance.database;

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

  Future<List<Map<String, dynamic>>> queryAllRowsByStateOrderByTitle(int state) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnState = $state ORDER BY title');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDownloadedDesc() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnDownloaded = 1 ORDER BY id_playlist DESC');
  }

  Future<List<Map<String, dynamic>>> queryAllRowsDownloadedOrderByTitle() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnDownloaded = 1 ORDER BY title');
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

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<void> insertBatchForBackup(List<Map<String, dynamic>> list) async {
    Database db = await instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final data in list) {
        batch.insert(table, data);
      }

      await batch.commit(noResult: true);
    });
  }
}
