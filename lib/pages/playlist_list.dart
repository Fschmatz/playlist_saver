import 'dart:async';
import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:playlist_saver/pages/save_playlist.dart';
import 'package:playlist_saver/widgets/playlist_tile.dart';

class PlaylistList extends StatefulWidget {
  int stateValue;

  PlaylistList({Key? key, required this.stateValue}) : super(key: key);

  @override
  _PlaylistListState createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  List<Map<String, dynamic>> playlists = [];
  final dbPlaylist = PlaylistDao.instance;
  bool loading = true;

  @override
  void initState() {
    getPlaylists();
    super.initState();
  }

  void getPlaylists() async {
    if (widget.stateValue == 3) {
      playlists = await dbPlaylist.queryAllRowsDownloadedDesc();
    } else {
      playlists = await dbPlaylist.queryAllRowsDescState(widget.stateValue);
    }
    setState(() {
      loading = false;
      //playlists = resp;
    });
  }

  void removeFromList(int index) {
    setState(() {
      playlists = List.from(playlists)..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading)
          ? const Center(child: SizedBox.shrink())
          : ListView(
              children: [
                ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 2,
                  ),
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, int index) {
                    return PlaylistTile(
                      key: UniqueKey(),
                      removeFromList: removeFromList,
                      index: index,
                      refreshHome: getPlaylists,
                      isPageDownloads: widget.stateValue == 3 ? true : false,
                      playlist: Playlist(
                        idPlaylist: playlists[index]['id_playlist'],
                        link: playlists[index]['link'],
                        title: playlists[index]['title'],
                        state: playlists[index]['state'],
                        artist: playlists[index]['artist'],
                        downloaded: playlists[index]['downloaded'],
                        cover: playlists[index]['cover'],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
    );
  }
}
