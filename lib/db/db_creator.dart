import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbCreator {

  static const _databaseName = "PlaylistSaver.db";
  static const _databaseVersion = 1;
  static Database? _database;
  Future<Database> get database async =>
      _database ??= await initDatabase();

  DbCreator._privateConstructor();
  static final DbCreator instance = DbCreator._privateConstructor();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {

    await db.execute('''    
           CREATE TABLE playlists (
             id_playlist INTEGER PRIMARY KEY,
             link TEXT NOT NULL,
             title TEXT NOT NULL,
             state INTEGER NOT NULL,            
             artist TEXT,
             downloaded INTEGER NOT NULL,              
             cover BLOB
          )          
          ''');

    await db.execute('''       
          CREATE TABLE tags (
            id_tag INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          )
          ''');

    await db.execute(''' 
          CREATE TABLE playlists_tags (
            id_playlist INTEGER NOT NULL,
            id_tag INTEGER NOT NULL
          )
          ''');

    Batch batch = db.batch();

    batch.insert('tags', {
      'id_tag': 1,
      'name': 'New Album'
    });
    batch.insert('tags', {
      'id_tag': 2,
      'name': 'Artist'
    });
    batch.insert('tags', {
      'id_tag': 3,
      'name': 'Compilation'
    });
    batch.insert('tags', {
      'id_tag': 4,
      'name': 'Reading'
    });
    batch.insert('tags', {
      'id_tag': 5,
      'name': 'Lo-Fi'
    });
    batch.insert('tags', {
      'id_tag': 6,
      'name': 'Live'
    });

    await batch.commit(noResult: true);
  }
}

