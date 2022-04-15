import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:playlist_saver/pages/savePlaylist.dart';
import 'package:playlist_saver/widgets/playlist_tile.dart';
import 'configs/settings_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> playlists = [];
  final dbPlaylist = PlaylistDao.instance;
  bool loading = true;

  @override
  void initState() {
    getAllPlaylists();
    super.initState();

    /*ShareService()
      ..onDataReceived = _handleSharedData
      ..getSharedData().then(_handleSharedData);*/
  }

  void getAllPlaylists() async {
    var resp = await dbPlaylist.queryAllRows();
    setState(() {
      loading = false;
      playlists = resp;
    });
  }

  String _sharedText = "";

  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              title: const Text('Playlist Saver'),
              pinned: false,
              floating: true,
              snap: true,
              actions: [
                IconButton(
                    icon: const Icon(
                      Icons.add_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SavePlaylist(),
                            fullscreenDialog: true,
                          ));
                    }),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SettingsPage(),
                            fullscreenDialog: true,
                          ));
                    }),
              ])
        ];
      },
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
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
                        playlist: Playlist(
                          idPlaylist: playlists[index]['id_playlist'],
                          link: playlists[index]['link'],
                          title: playlists[index]['title'],
                          artist: playlists[index]['artist'],
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
    ));
  }
}

//https://open.spotify.com/playlist/3URc9oCOg6vN3gqF9MegOc?si=eQ-W24iKTOelGrzdAblsBA&utm_source=native-share-menu&nd=1
