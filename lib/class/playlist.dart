import 'dart:convert';
import 'dart:typed_data';

import 'package:playlist_saver/db/playlist_dao.dart';

class Playlist {
  int? idPlaylist;
  String link;
  String title;
  int state; //0 listen, 1 archive, 2 favorite
  String? artist;
  int? downloaded; //0 false, 1 true
  Uint8List? cover;
  int? newAlbum; //0 false, 1 true

  Playlist({
    this.idPlaylist,
    required this.link,
    required this.title,
    required this.state,
    this.artist,
    this.downloaded,
    this.cover,
    this.newAlbum,
  });

  bool isDownloaded() {
    return downloaded == 1 ? true : false;
  }

  bool isNewAlbum() {
    return newAlbum == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    return {
      'idPlaylist': idPlaylist,
      'link': link,
      'title': title,
      'state': state,
      'artist': artist,
      'downloaded': downloaded,
      'cover': cover != null ? base64Encode(cover!) : null,
      'newAlbum': newAlbum,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      idPlaylist: map[PlaylistDao.columnIdPlaylist],
      link: map[PlaylistDao.columnLink],
      title: map[PlaylistDao.columnTitle],
      state: map[PlaylistDao.columnState],
      artist: map[PlaylistDao.columnArtist],
      downloaded: map[PlaylistDao.columnDownloaded],
      cover: map[PlaylistDao.columnCover],
      newAlbum: map[PlaylistDao.columnNewAlbum],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idPlaylist != null) PlaylistDao.columnIdPlaylist: idPlaylist,
      PlaylistDao.columnLink: link,
      PlaylistDao.columnTitle: title,
      PlaylistDao.columnState: state,
      PlaylistDao.columnArtist: artist,
      PlaylistDao.columnDownloaded: downloaded,
      PlaylistDao.columnCover: cover,
      PlaylistDao.columnNewAlbum: newAlbum,
    };
  }

  Playlist copyWith({
    int? idPlaylist,
    String? link,
    String? title,
    int? state,
    String? artist,
    int? downloaded,
    Uint8List? cover,
    int? newAlbum,
  }) {
    return Playlist(
      idPlaylist: idPlaylist ?? this.idPlaylist,
      link: link ?? this.link,
      title: title ?? this.title,
      state: state ?? this.state,
      artist: artist ?? this.artist,
      downloaded: downloaded ?? this.downloaded,
      cover: cover ?? this.cover,
      newAlbum: newAlbum ?? this.newAlbum,
    );
  }
}
