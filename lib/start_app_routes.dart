import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/share/receive_shared_playlist.dart';
import 'package:playlist_saver/util/theme.dart';
import 'package:share_handler/share_handler.dart';
import 'app.dart';
import 'class/init_data.dart';
import 'class/show_data_argument.dart';
import 'main.dart';

class StartAppRoutes extends StatefulWidget {
  StartAppRoutes({Key? key, required this.initData}) : super(key: key);

  InitData initData;

  @override
  _StartAppRoutesState createState() => _StartAppRoutesState();
}

class _StartAppRoutesState extends State<StartAppRoutes> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  SharedMedia? media;

  //Playlists made by Spotify contains a phrase
  var reg = RegExp(r'.*(?=https://)');

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  //app in memory
  Future<void> initPlatformState() async {
    final handler = ShareHandlerPlatform.instance;

    handler.sharedMediaStream.listen((SharedMedia media) {
      _navKey.currentState!.pushNamed(
        saveShareRoute,
        arguments: ShowDataArgument(media.content!),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      onGenerateRoute: (RouteSettings routeSettings) {
        switch (routeSettings.name) {
          case "/":
            return MaterialPageRoute(builder: (context) => const App());

          case "/saveShare":
            if (routeSettings.arguments != null) {
              final args = routeSettings.arguments as ShowDataArgument;
              return MaterialPageRoute(
                  builder: (context) => ReceiveSharedPlaylist(
                        sharedText: args.sharedText.replaceAll(reg,''),
                      ));
            } else {
              //Outside memory route
              return MaterialPageRoute(
                  builder: (_) => ReceiveSharedPlaylist(
                        sharedText: widget.initData.sharedText.replaceAll(reg,''),
                      ));
            }
        }
      },
      initialRoute: widget.initData.routeName,
    );
  }
}
