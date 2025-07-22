import '../enum/destination.dart';
import '../main.dart';
import '../redux/actions.dart';

abstract class StoreService {
  Future<void> loadPlaylists(Destination destination) async {
    await store.dispatch(LoadPlaylistsAction(destination));
  }
}
