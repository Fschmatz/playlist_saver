import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../../util/app_details.dart';
import '../../util/dialog_backup.dart';
import '../../util/dialog_select_theme.dart';
import '../../util/utils.dart';
import '../print_playlist_list.dart';
import 'app_info.dart';
import 'changelog.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => SettingsState();

  const Settings({super.key});
}

class SettingsState extends State<Settings> {
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
              subtitle: Text(Utils().getThemeStringFormatted(EasyDynamicTheme.of(context).themeMode)),
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
                    return DialogBackup(
                      isCreateBackup: true,
                    );
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
                    return DialogBackup(
                      isCreateBackup: false,
                    );
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
