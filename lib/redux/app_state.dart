import 'package:playlist_saver/enum/destination.dart';

import '../class/app_parameter.dart';
import '../class/playlist.dart';

class AppState {
  List<Playlist> listListen;
  List<Playlist> listArchive;
  List<Playlist> listFavorites;
  List<Playlist> listDownloads;
  Destination currentDestination;
  List<AppParameter> appParameters;

  AppState(
      {required this.listListen,
      required this.listArchive,
      required this.listFavorites,
      required this.listDownloads,
      required this.currentDestination,
      required this.appParameters});

  static AppState initialState() => AppState(
      listListen: [],
      listArchive: [],
      listFavorites: [],
      listDownloads: [],
      currentDestination: Destination.listen,
      appParameters: []);

  AppState copyWith(
      {List<Playlist>? listListen,
      List<Playlist>? listArchive,
      List<Playlist>? listFavorites,
      List<Playlist>? listDownloads,
      Destination? currentDestination,
      List<AppParameter>? appParameters}) {
    return AppState(
        listListen: listListen ?? this.listListen,
        listArchive: listArchive ?? this.listArchive,
        listFavorites: listFavorites ?? this.listFavorites,
        listDownloads: listDownloads ?? this.listDownloads,
        currentDestination: currentDestination ?? this.currentDestination,
        appParameters: appParameters ?? this.appParameters);
  }
}
