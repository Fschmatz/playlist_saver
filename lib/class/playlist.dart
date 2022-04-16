import 'dart:typed_data';

class Playlist{

  int idPlaylist;
  String link;
  String title;
  String? artist;
  String? tags;
  Uint8List? cover;

  Playlist({
    required this.idPlaylist,
    required this.link,
    required this.title,
    this.tags,
    this.artist,
    this.cover});

}