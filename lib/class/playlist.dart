import 'dart:typed_data';

class Playlist{

  int idPlaylist;
  String link;
  String title;
  String? artist;
  Uint8List? cover;

  Playlist({
    required this.idPlaylist,
    required this.link,
    required this.title,
    this.artist,
    this.cover});

}