import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:playlist_saver/pages/playlist_list.dart';
import 'package:playlist_saver/pages/save_playlist.dart';
import 'package:playlist_saver/pages/tags/tags_manager.dart';
import 'configs/settings_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  List<Widget> _tabs = [
    PlaylistList(
      key: UniqueKey(),
      archivedValue: 0,
    ),
    PlaylistList(
      key: UniqueKey(),
      archivedValue: 1,
    ),
  ];

  void refresh() {
    setState(() {
      _tabs = [
        PlaylistList(
          key: UniqueKey(),
          archivedValue: 0,
        ),
        PlaylistList(
          key: UniqueKey(),
          archivedValue: 1,
        ),
      ];
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
                  PopupMenuButton<int>(
                      icon: const Icon(Icons.more_vert_outlined),
                      itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<int>>[
                        const PopupMenuItem<int>(
                            value: 0, child: Text('Add playlist')),
                        const PopupMenuItem<int>(
                            value: 1, child: Text('Manage tags')),
                        const PopupMenuItem<int>(
                            value: 2, child: Text('Settings')),
                      ],
                      onSelected: (int value) {
                        if (value == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SavePlaylist(
                                  refreshHome: refresh,
                                ),
                              ));
                        } else if (value == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                const TagsManager(),
                              )).then((value) => refresh());
                        } else if (value == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                const SettingsPage(),
                              ));
                        }
                      })
                ],
              ),
            ];
          },
          body: PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  ),
              child: _tabs[_currentTabIndex])),
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
            ),
            label: 'Listen',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive_outlined),
            selectedIcon: Icon(
              Icons.archive,
            ),
            label: 'Archive',
          ),
        ],
      ),
    );
  }
}

