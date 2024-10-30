import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/service/playlist_service.dart';
import 'package:playlist_saver/widgets/playlist_tile_grid.dart';

class PlaylistList extends StatefulWidget {
  final int stateValue;

  const PlaylistList({super.key, required this.stateValue});

  @override
  State<PlaylistList> createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> with AutomaticKeepAliveClientMixin<PlaylistList> {
  @override
  bool get wantKeepAlive => true;

  List<Playlist> _playlists = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    getPlaylists();
  }

  void getPlaylists() async {
    _playlists = await PlaylistService().queryAllByStateAndConvertToList(widget.stateValue);

    setState(() {
      loading = false;
    });
  }

  void removeFromList(int index) {
    setState(() {
      _playlists = List.from(_playlists)..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return (loading && mounted)
        ? const Center(child: SizedBox.shrink())
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: 170),
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _playlists.length,
                  itemBuilder: (context, index) {
                    return PlaylistTileGrid(
                        key: UniqueKey(),
                        removeFromList: removeFromList,
                        index: index,
                        refreshHome: getPlaylists,
                        isPageDownloads: widget.stateValue == 3 ? true : false,
                        playlist: _playlists[index]);
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          );
  }
}
