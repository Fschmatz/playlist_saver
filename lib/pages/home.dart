import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:playlist_saver/pages/playlist_list.dart';
import 'package:playlist_saver/pages/save_playlist.dart';
import 'package:playlist_saver/pages/tags/tags_manager.dart';
import '../util/app_details.dart';
import 'configs/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  ScrollController scrollController = ScrollController();
  List<Widget> _tabs = [
    PlaylistList(
      key: UniqueKey(),
      stateValue: 0,
    ),
    PlaylistList(
      key: UniqueKey(),
      stateValue: 1,
    ),
    PlaylistList(
      key: UniqueKey(),
      stateValue: 2,
    ),
    PlaylistList(
      key: UniqueKey(),
      stateValue: 3,
    ),
  ];

  void refresh() {
    setState(() {
      _tabs = [
        PlaylistList(
          key: UniqueKey(),
          stateValue: 0,
        ),
        PlaylistList(
          key: UniqueKey(),
          stateValue: 1,
        ),
        PlaylistList(
          key: UniqueKey(),
          stateValue: 2,
        ),
        PlaylistList(
          key: UniqueKey(),
          stateValue: 3,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(AppDetails.appNameHomePage),
                pinned: false,
                floating: true,
                snap: true,
                actions: [
                  PopupMenuButton<int>(
                      icon: const Icon(Icons.more_vert_outlined),
                      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                            const PopupMenuItem<int>(value: 0, child: Text('New playlist')),
                            const PopupMenuItem<int>(value: 1, child: Text('Tags')),
                            const PopupMenuItem<int>(value: 2, child: Text('Settings')),
                          ],
                      onSelected: (int value) {
                        switch (value) {
                          case 0:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SavePlaylist(
                                    refreshHome: refresh,
                                  ),
                                ));
                            break;
                          case 1:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const TagsManager(),
                                )).then((value) => refresh());
                            break;
                          case 2:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Settings(refreshHome: refresh),
                                ));
                        }
                      })
                ],
              ),
            ];
          },
          body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, animation, secondaryAnimation) => FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    ),
                child: _tabs[_currentTabIndex]),
          )),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) {
          scrollController.jumpTo(0);
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
          NavigationDestination(
            icon: Icon(Icons.favorite_border_outlined),
            selectedIcon: Icon(
              Icons.favorite_outlined,
            ),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.download_outlined),
            selectedIcon: Icon(
              Icons.download,
            ),
            label: 'Downloads',
          ),
        ],
      ),
    );
  }
}
