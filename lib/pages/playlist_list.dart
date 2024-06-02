import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:playlist_saver/service/playlist_service.dart';
import 'package:playlist_saver/widgets/playlist_tile.dart';
import 'package:playlist_saver/widgets/playlist_tile_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistList extends StatefulWidget {
  int stateValue;

  PlaylistList({Key? key, required this.stateValue}) : super(key: key);

  @override
  _PlaylistListState createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> with AutomaticKeepAliveClientMixin<PlaylistList> {
  @override
  bool get wantKeepAlive => true;

  List<Playlist> _playlists = [];
  bool loading = true;
  bool _useGridView = false;

  @override
  void initState() {
    super.initState();

    getPlaylists();
    _loadGridViewSetting();
  }

  void getPlaylists() async {
    _playlists = await PlaylistService().queryAllByStateAndConvertToList(widget.stateValue);

    setState(() {
      loading = false;
    });
  }

  void _loadGridViewSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _useGridView = prefs.getBool('useGridView') ?? false;
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
                _useGridView
                    ? Padding(
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
                      )
                    : ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => const SizedBox(
                          height: 2,
                        ),
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _playlists.length,
                        itemBuilder: (context, int index) {
                          return PlaylistTile(
                              key: UniqueKey(),
                              removeFromList: removeFromList,
                              index: index,
                              refreshHome: getPlaylists,
                              isPageDownloads: widget.stateValue == 3 ? true : false,
                              playlist: _playlists[index]);
                        },
                      ),
                const SizedBox(
                  height: 50,
                )
              ],
            );
  }
}
