import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:playlist_saver/share/share_save_playlist.dart';
import 'package:playlist_saver/util/theme.dart';
import 'app.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'class/init_data.dart';
import 'class/show_data_argument.dart';
import 'db/db_creator.dart';

const String homeRoute = "home";
const String showDataRoute = "showData";

Future<InitData> init() async {
  String sharedText = "";
  String routeName = homeRoute;
  String? sharedValue = await ReceiveSharingIntent.getInitialText();
  if (sharedValue != null) {
    sharedText = sharedValue;
    routeName = showDataRoute;

    ReceiveSharingIntent.reset();
  }
  return InitData(sharedText, routeName);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitData initData = await init();

  final dbCreator = DbCreator.instance;
  dbCreator.initDatabase();

  runApp(
    EasyDynamicThemeWidget(
      child: StartAppRoutes(
        initData: initData,
      ),
    ),
  );
}

class StartAppRoutes extends StatefulWidget {
  const StartAppRoutes({Key? key, required this.initData}) : super(key: key);

  final InitData initData;

  @override
  _StartAppRoutesState createState() => _StartAppRoutesState();
}

class _StartAppRoutesState extends State<StartAppRoutes> {
  final _navKey = GlobalKey<NavigatorState>();
  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      _navKey.currentState!.pushNamed(
        showDataRoute,
        arguments: ShowDataArgument(value),
      );
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case homeRoute:
            return MaterialPageRoute(builder: (_) => const App());
          case showDataRoute:
            {
              if (settings.arguments != null) {
                final args = settings.arguments as ShowDataArgument;
                return MaterialPageRoute(
                    builder: (_) => ShareSavePlaylist(
                          sharedText: args.sharedText,
                        ));
              } else {
                return MaterialPageRoute(
                    builder: (_) => ShareSavePlaylist(
                          sharedText: widget.initData.sharedText,
                        ));
              }
            }
        }
      },
      initialRoute: widget.initData.routeName,
    );
  }
}