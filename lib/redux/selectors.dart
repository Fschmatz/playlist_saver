import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/enum/destination.dart';

import '../class/app_parameter.dart';
import '../main.dart';

List<Playlist> selectPlaylistByDestination(Destination destination) {
  switch (destination) {
    case Destination.listen:
      return store.state.listListen;
    case Destination.archive:
      return store.state.listArchive;
    case Destination.favorites:
      return store.state.listFavorites;
    case Destination.downloads:
      return store.state.listDownloads;
  }
}

Destination selectCurrentDestination() => store.state.currentDestination;

List<AppParameter> selectAppParameters() => store.state.appParameters;

String? selectParameterValueByKey(String key) {
  try {
    return store.state.appParameters.firstWhere((element) => element.getKey() == key).getValue();
  } catch (e) {
    return null;
  }
}

bool selectParameterValueByKeyAsBoolean(String key, {bool defaultValue = true}) {
  String? value = selectParameterValueByKey(key);

  if (value == null) {
    return defaultValue;
  }

  return value == "true";
}
