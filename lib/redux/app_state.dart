import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_saver/enum/destination.dart';

import '../class/app_parameter.dart';
import '../class/playlist.dart';

class AppState {
  List<Playlist> listListen;
  List<Playlist> listArchive;
  List<Playlist> listFavorites;
  List<Playlist> listDownloads;
  List<Playlist> listAll;
  Destination currentDestination;
  List<AppParameter> appParameters;

  AppState(
      {required this.listListen,
      required this.listArchive,
      required this.listFavorites,
      required this.listDownloads,
      required this.listAll,
      required this.currentDestination,
      required this.appParameters});

  static AppState initialState() => AppState(
      listListen: [], listArchive: [], listFavorites: [], listDownloads: [], listAll: [], currentDestination: Destination.listen, appParameters: []);

  AppState copyWith(
      {List<Playlist>? listListen,
      List<Playlist>? listArchive,
      List<Playlist>? listFavorites,
      List<Playlist>? listDownloads,
      List<Playlist>? listAll,
      Destination? currentDestination,
      List<AppParameter>? appParameters}) {
    return AppState(
        listListen: listListen ?? this.listListen,
        listArchive: listArchive ?? this.listArchive,
        listFavorites: listFavorites ?? this.listFavorites,
        listDownloads: listDownloads ?? this.listDownloads,
        listAll: listAll ?? this.listAll,
        currentDestination: currentDestination ?? this.currentDestination,
        appParameters: appParameters ?? this.appParameters);
  }
}

extension BuildContextExtension on BuildContext {
  AppState get state => getState<AppState>();

  AppState read() => getRead<AppState>();

  R select<R>(R Function(AppState state) selector) => getSelect<AppState, R>(selector);

  R? event<R>(Evt<R> Function(AppState state) selector) => getEvent<AppState, R>(selector);
}
