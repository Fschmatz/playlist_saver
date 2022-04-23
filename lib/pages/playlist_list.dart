import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:playlist_saver/pages/savePlaylist.dart';
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
    getAllPlaylists();
    super.initState();
  }

  void getAllPlaylists() async {
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
          duration: const Duration(milliseconds: 650),
          child: loading
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
                          refreshHome: getAllPlaylists,
                          playlist: Playlist(
                            idPlaylist: playlists[index]['id_playlist'],
                            link: playlists[index]['link'],
                            title: playlists[index]['title'],
                            archived: playlists[index]['archived'],
                            artist: playlists[index]['artist'],
                            tags: playlists[index]['tags'],
                            cover: playlists[index]
                                ['cover'], //playlists[index]['cover']
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
        floatingActionButton: widget.archivedValue == 1
            ? null
            : FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => SavePlaylist(
                          refreshHome: getAllPlaylists,
                        ),
                        fullscreenDialog: true,
                      ));
                },
                child: Icon(
                  Icons.add_outlined,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ));
  }
}
