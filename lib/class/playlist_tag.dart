class PlaylistTag{

  int idPlaylist;
  int idTag;

  PlaylistTag(this.idTag, this.idPlaylist);

  Map<String, dynamic> toJson() {
    return {
      'idPlaylist': idPlaylist,
      'idTag': idTag,
    };
  }

  factory PlaylistTag.fromMap(Map<String, dynamic> map) {
    return PlaylistTag(
        map['id_playlist'],
        map['id_tag']
    );
  }
}