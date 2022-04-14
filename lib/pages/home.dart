import 'package:flutter/material.dart';

import '../util/share_service.dart';
import '../widgets/app_bar_sliver.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _sharedText = "";

  @override
  void initState() {
    super.initState();

    ShareService()
      ..onDataReceived = _handleSharedData
      ..getSharedData().then(_handleSharedData);
  }

  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[const AppBarSliver()];
    },
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _sharedText,
          style: const TextStyle(
            fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    )));
  }
}
