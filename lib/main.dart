import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:playlist_saver/start_app_routes.dart';
import 'package:share_handler/share_handler.dart';
import 'class/init_data.dart';
import 'db/db_creator.dart';

const String homeRoute = "home";
const String showDataRoute = "showData";

Future<InitData> init() async {
  String sharedText = "";
  String routeName = homeRoute;
  final handler = ShareHandlerPlatform.instance;

  SharedMedia? sharedValue = await handler.getInitialSharedMedia();

  if (sharedValue != null) {
    sharedText = sharedValue.content!;
    routeName = showDataRoute;
    handler.resetInitialSharedMedia();
  }

  return InitData(sharedText, routeName);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbCreator = DbCreator.instance;
  dbCreator.initDatabase();

  //app not in memory
  InitData initData = await init();

  runApp(
    EasyDynamicThemeWidget(
      child: StartAppRoutes(
        initData: initData,
      ),
    ),
  );
}

