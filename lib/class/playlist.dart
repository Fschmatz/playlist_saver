import 'dart:typed_data';

class Playlist{

  int idPlaylist;
  String link;
  String title;
  int state; //0 listen, 1 archive, 2 favorite
  String? artist;
  Uint8List? cover;

  Playlist({
    required this.idPlaylist,
    required this.link,
    required this.title,
    required this.state,
    this.artist,
    this.cover});

}