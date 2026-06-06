import 'package:playlist_saver/service/app_parameter_service.dart';

import '../class/app_parameter.dart';
import '../enum/destination.dart';
import '../service/playlist_service.dart';
import '../service/widget_service.dart';
import 'app_state.dart';
import 'helper/app_action.dart';

class LoadAppParametersAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<AppParameter> parameters = await AppParameterService().getAll();

    return state.copyWith(appParameters: parameters);
  }
}

class SaveAppParameterAction extends AppAction {
  final AppParameter appParameter;

  SaveAppParameterAction(this.appParameter);

  @override
  Future<AppState> reduce() async {
    await AppParameterService().saveParameter(appParameter);

    return state;
  }
}

class LoadPlaylistsAction extends AppAction {
  final Destination destination;
  final bool forceReload;

  LoadPlaylistsAction(this.destination, {this.forceReload = false});

  @override
  Future<AppState> reduce() async {
    final cached = switch (destination) {
      Destination.listen => state.listListen,
      Destination.archive => state.listArchive,
      Destination.favorites => state.listFavorites,
      Destination.downloads => state.listDownloads,
      Destination.all => state.listAll,
    };

    final playlists = cached.isEmpty || forceReload ? await PlaylistService().queryAllByStateAndConvertToList(destination.id) : cached;


    return switch (destination) {
      Destination.listen => state.copyWith(listListen: playlists, currentDestination: destination),
      Destination.archive => state.copyWith(listArchive: playlists, currentDestination: destination),
      Destination.favorites => state.copyWith(listFavorites: playlists, currentDestination: destination),
      Destination.downloads => state.copyWith(listDownloads: playlists, currentDestination: destination),
      Destination.all => state.copyWith(listAll: playlists, currentDestination: destination),
    };
  }
}

class ChangeDestinationAction extends AppAction {
  final Destination destination;

  ChangeDestinationAction(this.destination);

  @override
  AppState reduce() {
    return state.copyWith(currentDestination: destination);
  }
}
