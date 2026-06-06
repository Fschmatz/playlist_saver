import 'package:flutter/material.dart';

enum PlaylistStatus {
  listen(0, 'Listen', Icons.queue_music_outlined),
  archive(1, 'Archive', Icons.archive_outlined),
  favorite(2, 'Favorite', Icons.favorite_border_outlined);

  const PlaylistStatus(this.id, this.name, this.icon);

  final int id;
  final String name;
  final IconData icon;

  static PlaylistStatus fromId(int id) {
    return PlaylistStatus.values.firstWhere((e) => e.id == id, orElse: () => PlaylistStatus.listen);
  }
}
