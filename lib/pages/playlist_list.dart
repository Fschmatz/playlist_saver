import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:playlist_saver/pages/save_playlist.dart';
import 'package:playlist_saver/widgets/playlist_tile.dart';

class PlaylistList extends StatefulWidget {
  int archivedValue;

  PlaylistList({Key? key, required this.archivedValue}) : super(key: key);

  @override
  _PlaylistListState createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList> {
  List<Map<String, dynamic>> playlists = [];
  final dbPlaylist = PlaylistDao.instance;
  bool loading = true;

  @override
  void initState() {
    getPlaylists(false);
    super.initState();
  }

  void getPlaylists([bool refresh = true]) async {
    if (refresh) {
      setState(() {
        loading = true;
      });
    }
    var resp = await dbPlaylist.queryAllRowsDescArchive(widget.archivedValue);
    setState(() {
      loading = false;
      playlists = resp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: (loading)
              ? const Center(child: SizedBox.shrink())
              : ListView(
                  children: [
                    ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 4,
                      ),
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: playlists.length,
                      itemBuilder: (context, int index) {
                        return PlaylistTile(
                          key: UniqueKey(),
                          refreshHome: getPlaylists,
                          playlist: Playlist(
                            idPlaylist: playlists[index]['id_playlist'],
                            link: playlists[index]['link'],
                            title: playlists[index]['title'],
                            archived: playlists[index]['archived'],
                            artist: playlists[index]['artist'],
                            cover: playlists[index]
                                ['cover'],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
        ),
    );
  }
}
