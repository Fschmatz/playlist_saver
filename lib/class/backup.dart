import 'dart:convert';

class Backup {

  List<Map<String, dynamic>> playlists;
  List<Map<String, dynamic>> tags;
  List<Map<String, dynamic>> playlistTags;

  Backup({required this.playlists, required this.tags, required this.playlistTags});

  factory Backup.fromJson(Map<String, dynamic> json) {
    return Backup(
      playlists: List<Map<String, dynamic>>.from(json['playlists']),
      tags: List<Map<String, dynamic>>.from(json['tags']),
      playlistTags: List<Map<String, dynamic>>.from(json['playlistTags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playlists': playlists,
      'tags': tags,
      'playlistTags': playlistTags,
    };
  }

}
