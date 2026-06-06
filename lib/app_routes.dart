import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/pages/home.dart';
import 'package:playlist_saver/share/receive_shared_playlist.dart';
import 'package:share_handler/share_handler.dart';

import 'class/init_data.dart';
import 'class/show_data_argument.dart';
import 'main.dart';

class AppRoutes extends StatefulWidget {
  const AppRoutes({super.key, required this.initData});

  final InitData initData;

  @override
  State<AppRoutes> createState() => _AppRoutesState();
}

class _AppRoutesState extends State<AppRoutes> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  SharedMedia? media;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      final lightScheme = lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue);
      final darkScheme = darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

      ThemeData buildTheme(ColorScheme colorScheme) {
        return ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
          appBarTheme: AppBarThemeData(
            elevation: 0,
          ),
          dividerTheme: DividerThemeData(color: colorScheme.surfaceContainerLow, space: 1),
          cardTheme: CardThemeData(
            color: colorScheme.surfaceContainerHigh,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: colorScheme.surfaceContainerHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        );
      }

      return MaterialApp(
        navigatorKey: _navKey,
        debugShowCheckedModeBanner: false,
        theme: buildTheme(lightScheme),
        darkTheme: buildTheme(darkScheme),
        themeMode: EasyDynamicTheme.of(context).themeMode,
        onGenerateRoute: (RouteSettings routeSettings) {
          switch (routeSettings.name) {
            case "/":
              return MaterialPageRoute(builder: (context) => const Home());

            case "/saveShare":
              if (routeSettings.arguments != null || widget.initData.sharedText.isEmpty) {
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
              return MaterialPageRoute(builder: (context) => const Home());
          }
        },
        initialRoute: widget.initData.routeName,
      );
    });
  }
}
