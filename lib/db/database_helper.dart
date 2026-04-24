import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static const _databaseName = "PlaylistSaver.db";
  static const _databaseVersion = 2;

  // Playlists
  static const tablePlaylists = 'playlists';
  static const columnIdPlaylist = 'id_playlist';
  static const columnLink = 'link';
  static const columnTitle = 'title';
  static const columnState = 'state';
  static const columnArtist = 'artist';
  static const columnDownloaded = 'downloaded';
  static const columnCover = 'cover';
  static const columnNewAlbum = 'new_album';

  // App Parameters
  static const tableAppParameters = 'app_parameters';
  static const columnParamKey = 'key';
  static const columnParamValue = 'value';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async =>
      _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''    
           CREATE TABLE $tablePlaylists (
             $columnIdPlaylist INTEGER PRIMARY KEY,
             $columnLink TEXT NOT NULL,
             $columnTitle TEXT NOT NULL,
             $columnState INTEGER NOT NULL,            
             $columnArtist TEXT,
             $columnDownloaded INTEGER NOT NULL,              
             $columnCover BLOB,
             $columnNewAlbum INTEGER NOT NULL
          )          
          ''');

    await db.execute('''
          CREATE TABLE $tableAppParameters (
            $columnParamKey TEXT PRIMARY KEY,
            $columnParamValue TEXT
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
          CREATE TABLE $tableAppParameters (
            $columnParamKey TEXT PRIMARY KEY,
            $columnParamValue TEXT
          )
          ''');
    }
  }
}

