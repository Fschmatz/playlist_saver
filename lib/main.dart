import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/share/share_save_playlist.dart';
import 'package:playlist_saver/share/show_data_argument.dart';
import 'package:playlist_saver/util/theme.dart';
import 'app.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'share/init_data.dart';

const String homeRoute = "home";
const String showDataRoute = "showData";

Future<InitData> init() async {
  String sharedText = "";
  String routeName = homeRoute;
  String? sharedValue = await ReceiveSharingIntent.getInitialText();
  if (sharedValue != null) {
    sharedText = sharedValue;
    routeName = showDataRoute;
  }
  return InitData(sharedText, routeName);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitData initData = await init();

  runApp(
    EasyDynamicThemeWidget(
      child: StartAppTheme(
        initData: initData,
      ),
    ),
  );
}

class StartAppTheme extends StatefulWidget {
  const StartAppTheme({Key? key, required this.initData}) : super(key: key);

  final InitData initData;

  @override
  _StartAppThemeState createState() => _StartAppThemeState();
}

class _StartAppThemeState extends State<StartAppTheme> {
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
    super.dispose();
    _intentDataStreamSubscription.cancel();
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
