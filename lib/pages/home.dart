import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:playlist_saver/pages/playlist_list.dart';
import 'package:playlist_saver/pages/save_playlist.dart';
import 'package:playlist_saver/util/app_constants.dart';

import '../enum/destination.dart';
import '../main.dart';
import '../redux/actions.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();

  const Home({super.key});
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;

  final List<Destination> _activeDestinations = [
    Destination.listen,
    Destination.archive,
    Destination.favorites,
    Destination.downloads,
    Destination.all,
  ];

  void _executeOnDestinationSelected(int index) async {
    final selectedDestination = _activeDestinations[index];

    await store.dispatch(LoadPlaylistsAction(selectedDestination));

    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appNameHomePage),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert_outlined),
            itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: const [
                    Icon(Icons.add_outlined),
                    SizedBox(width: 12),
                    Text('Add playlist'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
            onSelected: (int value) {
              switch (value) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SavePlaylist(),
                    ),
                  );
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Settings(),
                    ),
                  );
              }
            },
          )
        ],
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: _activeDestinations.asMap().entries.map((entry) {
                final int index = entry.key;
                final Destination dest = entry.value;
                final bool isSelected = _currentTabIndex == index;
                final colorscheme = Theme.of(context).colorScheme;

                return Padding(
                  padding: EdgeInsets.only(right: index == _activeDestinations.length - 1 ? 0 : 8),
                  child: FilterChip(
                    label: Text(dest.name),
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: IconTheme(
                      data: IconThemeData(
                        color: isSelected ? colorscheme.onPrimaryContainer : colorscheme.onSurfaceVariant,
                        size: 18,
                      ),
                      child: isSelected ? dest.selectedIcon : dest.icon,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    side: BorderSide.none,
                    selectedColor: colorscheme.primaryContainer,
                    backgroundColor: colorscheme.surfaceContainerHigh,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorscheme.onPrimaryContainer : colorscheme.onSurfaceVariant,
                    ),
                    onSelected: (bool selected) {
                      if (!isSelected) {
                        _executeOnDestinationSelected(index);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 450),
            transitionBuilder: (child, animation, secondaryAnimation) => FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            layoutBuilder: (List<Widget> entries) {
              return Stack(
                alignment: Alignment.topCenter,
                children: entries,
              );
            },
            child: PlaylistList(
              key: ValueKey(_activeDestinations[_currentTabIndex].id),
              destination: _activeDestinations[_currentTabIndex],
            ),
          ),
        ],
      ),
    );
  }
}
