import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:playlist_saver/enum/destination.dart';
import 'package:playlist_saver/redux/actions.dart';
import 'package:playlist_saver/redux/app_state.dart';
import 'package:playlist_saver/start_app_routes.dart';
import 'package:share_handler/share_handler.dart';

import 'class/init_data.dart';
import 'db/db_creator.dart';

const String homeRoute = "/";
const String saveShareRoute = "/saveShare";

Future<InitData> init() async {
  String sharedText = "";
  String routeName = homeRoute;
  final handler = ShareHandlerPlatform.instance;
  SharedMedia? sharedValue = await handler.getInitialSharedMedia();

  if (sharedValue != null) {
    sharedText = sharedValue.content!;
    routeName = saveShareRoute;
    handler.resetInitialSharedMedia();
  }

  return InitData(sharedText, routeName);
}

final Store<AppState> store = Store<AppState>(
  initialState: AppState.initialState(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbCreator = DbCreator.instance;
  dbCreator.initDatabase();

  //app not in memory
  InitData initData = await init();

  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 50;

  await store.dispatch(LoadPlaylistsAction(Destination.listen));

  runApp(
    StoreProvider<AppState>(
      store: store,
      child: EasyDynamicThemeWidget(
        child: StartAppRoutes(
          initData: initData,
        ),
      ),
    ),
  );
}
