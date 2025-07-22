import 'package:flutter/material.dart';

enum Destination {
  listen(
      0,
      "Listen",
      Icon(Icons.queue_music_outlined),
      Icon(
        Icons.queue_music,
      )),
  archive(
      1,
      "Archive",
      Icon(Icons.archive_outlined),
      Icon(
        Icons.archive,
      )),
  favorites(
      2,
      "Favorites",
      Icon(Icons.favorite_border_outlined),
      Icon(
        Icons.favorite_outlined,
      )),
  downloads(
      3,
      "Downloads",
      Icon(Icons.download_outlined),
      Icon(
        Icons.download,
      ));

  const Destination(this.id, this.name, this.icon, this.selectedIcon);

  final int id;
  final String name;
  final Icon icon;
  final Icon selectedIcon;

  static Destination fromId(int id) {
    return Destination.values.firstWhere((e) => e.id == id);
  }
}
