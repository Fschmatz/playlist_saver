import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_details.dart';
import '../../util/backup_utils.dart';
import '../../util/dialog_backup.dart';
import '../../util/dialog_select_theme.dart';
import '../print_playlist_list.dart';
import 'app_info.dart';
import 'changelog.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();

  Function() refreshHome;

  Settings({Key? key, required this.refreshHome}) : super(key: key);
}

class SettingsState extends State<Settings> {
  late bool _useGridView;
  final Completer<bool> _loadingCompleter = Completer<bool>();

  @override
  void initState() {
    _loadGridViewSetting();
    super.initState();
  }

  String getThemeStringFormatted() {
    String theme = EasyDynamicTheme.of(context).themeMode.toString().replaceAll('ThemeMode.', '');
    if (theme == 'system') {
      theme = 'system default';
    }
    return theme.replaceFirst(theme[0], theme[0].toUpperCase());
  }

  Future<void> _loadGridViewSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useGridView = prefs.getBool('useGridView') ?? false;
    });
    _loadingCompleter.complete(true);
  }

  void _saveGridViewSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('useGridView', value);
  }

  @override
  Widget build(BuildContext context) {
    Color themeColorApp = Theme.of(context).colorScheme.primary;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              elevation: 1,
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 25),
              color: themeColorApp,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: ListTile(
                title: Text(
                  "${AppDetails.appName} ${AppDetails.appVersion}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17.5, color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Text("General", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorApp)),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogSelectTheme();
                  }),
              leading: const Icon(Icons.brightness_6_outlined),
              title: const Text(
                "App theme",
              ),
              subtitle: Text(
                getThemeStringFormatted(),
              ),
            ),
            FutureBuilder(
              future: _loadingCompleter.future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SwitchListTile(
                    title: const Text('Use gridview'),
                    secondary: const Icon(Icons.grid_3x3_outlined),
                    value: _useGridView,
                    onChanged: (value) {
                      setState(() {
                        _useGridView = value;
                      });
                      _saveGridViewSetting(value);
                      widget.refreshHome();
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            ListTile(
              title: Text("Backup", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorApp)),
            ),
            ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const PrintPlaylistList(),
                  )),
              leading: const Icon(Icons.print_outlined),
              title: const Text(
                "Print playlists",
              ),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogBackup( isCreateBackup: true,  reloadHomeFunction: widget.refreshHome,);
                  }),
              leading: const Icon(Icons.save_outlined),
              title: const Text(
                "Backup now",
              ),
            ),
            ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogBackup( isCreateBackup: false,  reloadHomeFunction: widget.refreshHome,);
                  }),
              leading: const Icon(Icons.settings_backup_restore_outlined),
              title: const Text(
                "Restore from backup",
              ),
            ),
            ListTile(
              title: Text("About", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeColorApp)),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text(
                "App info",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const AppInfo(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.article_outlined,
              ),
              title: const Text(
                "Changelog",
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Changelog(),
                    ));
              },
            ),
          ],
        ));
  }
}
