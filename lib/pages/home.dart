import 'package:flutter/material.dart';
import 'package:playlist_saver/class/playlist.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:playlist_saver/pages/playlist_list.dart';
import 'package:playlist_saver/pages/save_playlist.dart';
import 'package:playlist_saver/widgets/playlist_tile.dart';
import 'configs/settings_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  final List<Widget> _tabs = [
    PlaylistList(
      key: UniqueKey(),
      archivedValue: 0,
    ),
    PlaylistList(
      key: UniqueKey(),
      archivedValue: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
                        Icons.settings_outlined,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SettingsPage(),
                            ));
                      }),
                ],
              ),
            ];
          },
          body: _tabs[_currentTabIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.queue_music_outlined),
            selectedIcon: Icon(
              Icons.queue_music,
              color: Colors.black87,
            ),
            label: 'Listen',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive_outlined),
            selectedIcon: Icon(
              Icons.archive,
              color: Colors.black87,
            ),
            label: 'Archive',
          ),
        ],
      ),
    );
  }
}
