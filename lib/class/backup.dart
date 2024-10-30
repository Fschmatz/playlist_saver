class Backup {

  List<Map<String, dynamic>> playlists;

  Backup({required this.playlists});

  factory Backup.fromJson(Map<String, dynamic> json) {
    return Backup(
      playlists: List<Map<String, dynamic>>.from(json['playlists'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playlists': playlists
    };
  }

}
