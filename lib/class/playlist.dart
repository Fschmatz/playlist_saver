import 'dart:convert';
import 'dart:typed_data';

class Playlist {
  int idPlaylist;
  String link;
  String title;
  int state; //0 listen, 1 archive, 2 favorite
  String? artist;
  int? downloaded; //0 false, 1 true
  Uint8List? cover;
  int? newAlbum; //0 false, 1 true

  Playlist(
      {required this.idPlaylist,
      required this.link,
      required this.title,
      required this.state,
      this.artist,
      this.downloaded,
      this.cover,
      this.newAlbum});

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
      idPlaylist: map['id_playlist'],
      link: map['link'],
      title: map['title'],
      state: map['state'],
      artist: map['artist'],
      downloaded: map['downloaded'],
      cover: map['cover'],
      newAlbum: map['new_album'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_playlist': idPlaylist,
      'link': link,
      'title': title,
      'state': state,
      'artist': artist,
      'downloaded': downloaded,
      'cover': cover,
      'new_album': newAlbum,
    };
  }
}
