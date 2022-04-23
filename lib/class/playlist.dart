import 'dart:typed_data';

class Playlist{

  int idPlaylist;
  String link;
  String title;
  int archived; //0 no, 1 yes
  String? artist;
  String? tags;
  Uint8List? cover;

  Playlist({
    required this.idPlaylist,
    required this.link,
    required this.title,
    required this.archived,
    this.tags,
    this.artist,
    this.cover});

}