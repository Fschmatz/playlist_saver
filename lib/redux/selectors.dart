import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/enum/destination.dart';

import '../class/app_parameter.dart';
import 'app_state.dart';

List<Playlist> selectPlaylistByDestination(AppState state, Destination destination) {
  return switch (destination) {
    Destination.listen => state.listListen,
    Destination.archive => state.listArchive,
    Destination.favorites => state.listFavorites,
    Destination.downloads => state.listDownloads,
    Destination.all => state.listAll,
  };
}

Destination selectCurrentDestination(AppState state) => state.currentDestination;

List<AppParameter> selectAppParameters(AppState state) => state.appParameters;

String? selectParameterValueByKey(AppState state, String key) {
  try {
    return state.appParameters.firstWhere((element) => element.getKey() == key).getValue();
  } catch (e) {
    return null;
  }
}

bool selectParameterValueByKeyAsBoolean(AppState state, String key, {bool defaultValue = true}) {
  String? value = selectParameterValueByKey(state, key);

  if (value == null) {
    return defaultValue;
  }

  return value == "true";
}
