import '../enum/destination.dart';
import '../main.dart';
import '../redux/actions.dart';

abstract class StoreService {
  Future<void> loadPlaylists(Destination destination) async {
    await store.dispatch(LoadPlaylistsAction(destination, forceReload: true));
  }

  Future<void> loadPlaylistsOnChangeState(int oldState, int newState) async {
    await store.dispatchAndWaitAll(
        [LoadPlaylistsAction(Destination.fromId(oldState), forceReload: true), LoadPlaylistsAction(Destination.fromId(newState), forceReload: true)]);
  }
}
