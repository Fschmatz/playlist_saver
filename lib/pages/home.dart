import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:playlist_saver/pages/playlist_list.dart';
import 'package:playlist_saver/pages/save_playlist.dart';

import '../enum/destination.dart';
import '../main.dart';
import '../redux/actions.dart';
import '../util/app_details.dart';
import 'configs/settings.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();

  const Home({super.key});
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<Destination> _activeDestinations = [
    Destination.listen,
    Destination.archive,
    Destination.favorites,
  ];

  void _executeOnDestinationSelected(int index) async {
    final selectedDestination = _activeDestinations[index];

    await store.dispatch(LoadPlaylistsAction(selectedDestination));
    await store.dispatch(ChangeDestinationAction(selectedDestination));

    setState(() {
      _currentTabIndex = index;
    });

    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollController,
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
                            const PopupMenuItem<int>(value: 0, child: Text('Add playlist')),
                            const PopupMenuItem<int>(value: 1, child: Text('Settings')),
                          ],
                      onSelected: (int value) {
                        switch (value) {
                          case 0:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SavePlaylist(),
                                ));
                            break;
                          case 1:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Settings(),
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
                duration: const Duration(milliseconds: 450),
                transitionBuilder: (child, animation, secondaryAnimation) => FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    ),
                child: PlaylistList(
                  key: ValueKey(_activeDestinations[_currentTabIndex].id),
                  destination: _activeDestinations[_currentTabIndex],
                )),
          )),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) async {
          _executeOnDestinationSelected(index);
        },
        destinations: _activeDestinations
            .map((d) => NavigationDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon,
                  label: d.name,
                ))
            .toList(),
      ),
    );
  }
}
