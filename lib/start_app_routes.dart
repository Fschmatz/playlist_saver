import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/share/share_save_playlist.dart';
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

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  //app in memory
  Future<void> initPlatformState() async {
    final handler = ShareHandlerPlatform.instance;
    media = await handler.getInitialSharedMedia();

    handler.sharedMediaStream.listen((SharedMedia media) {
      _navKey.currentState!.pushNamed(
        showDataRoute,
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
          case homeRoute:
            return MaterialPageRoute(builder: (_) => const App());

          case showDataRoute:
            if (routeSettings.arguments != null) {
              final args = routeSettings.arguments as ShowDataArgument;
              return MaterialPageRoute(
                  builder: (_) => ShareSavePlaylist(
                        sharedText: args.sharedText,
                      ));
            } else {
              //Outside memory route
              return MaterialPageRoute(
                  builder: (_) => ShareSavePlaylist(
                        sharedText: widget.initData.sharedText,
                      ));
            }
        }
      },
      initialRoute: widget.initData.routeName,
    );
  }
}
