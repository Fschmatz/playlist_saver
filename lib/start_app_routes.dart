import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/share/receive_shared_playlist.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    initPlatformState();
    super.initState();
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
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        navigatorKey: _navKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: lightDynamic,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic,
          useMaterial3: true,
        ),
        themeMode: EasyDynamicTheme.of(context).themeMode,
        onGenerateRoute: (RouteSettings routeSettings) {
          switch (routeSettings.name) {
            case "/":
              return MaterialPageRoute(builder: (context) => const App());

            case "/saveShare":
              if (routeSettings.arguments != null ||
                  widget.initData.sharedText.isEmpty) {
                final args = routeSettings.arguments as ShowDataArgument;
                return MaterialPageRoute(
                    builder: (_) => ReceiveSharedPlaylist(
                          sharedText: args.sharedText,
                        ));
              } else {
                //Outside memory route
                return MaterialPageRoute(
                    builder: (_) => ReceiveSharedPlaylist(
                          sharedText: widget.initData.sharedText,
                        ));
              }
            default:
              return MaterialPageRoute(builder: (context) => const App());
          }
        },
        initialRoute: widget.initData.routeName,
      );
    });
  }
}
