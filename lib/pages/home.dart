import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:playlist_saver/pages/savePlaylist.dart';
import 'package:playlist_saver/widgets/playlist_tile.dart';
import '../util/share_service.dart';
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
  String _sharedText = "";

  @override
  void initState() {
    getAllPlaylists();
    //checkShareIntent().then((value) => getAllPlaylists());
    super.initState();
  }

  Future<void> checkShareIntent() async {
    ShareService()
      ..onDataReceived = _handleSharedData
      ..getSharedData().then(_handleSharedData);
  }


  void getAllPlaylists() async {
    var resp = await dbPlaylist.queryAllRows();
    setState(() {
      loading = false;
      playlists = resp;
    });
  }


  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
    if(sharedData != null){
      Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => SavePlaylist(
              refreshHome: getAllPlaylists,
              linkFromShareIntent: _sharedText,
            ),
            fullscreenDialog: true,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar : AppBar(
            title: const Text('Playlist Saver'),
            actions: [
              IconButton(
                  icon: const Icon(
                    Icons.add_outlined,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => SavePlaylist(
                            refreshHome: getAllPlaylists,
                            linkFromShareIntent: '',
                          ),
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
            ]),



      body:
      AnimatedSwitcher(
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
                        refreshHome: getAllPlaylists,
                        playlist: Playlist(
                          idPlaylist: playlists[index]['id_playlist'],
                          link: playlists[index]['link'],
                          title: playlists[index]['title'],
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
    );
  }
}
