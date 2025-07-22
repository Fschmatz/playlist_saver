import 'package:playlist_saver/enum/destination.dart';

import '../class/playlist.dart';

class AppState {
  List<Playlist> listListen;
  List<Playlist> listArchive;
  List<Playlist> listFavorites;
  List<Playlist> listDownloads;
  Destination currentDestination;

  AppState(
      {required this.listListen,
      required this.listArchive,
      required this.listFavorites,
      required this.listDownloads,
      required this.currentDestination});

  static AppState initialState() =>
      AppState(listListen: [], listArchive: [], listFavorites: [], listDownloads: [], currentDestination: Destination.listen);

  AppState copyWith(
      {List<Playlist>? listListen,
      List<Playlist>? listArchive,
      List<Playlist>? listFavorites,
      List<Playlist>? listDownloads,
      Destination? currentDestination}) {
    return AppState(
        listListen: listListen ?? this.listListen,
        listArchive: listArchive ?? this.listArchive,
        listFavorites: listFavorites ?? this.listFavorites,
        listDownloads: listDownloads ?? this.listDownloads,
        currentDestination: currentDestination ?? this.currentDestination);
  }
}
