import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/db/playlist_dao.dart';

class PrintPlaylistList extends StatefulWidget {
  PrintPlaylistList({Key? key}) : super(key: key);

  @override
  _PrintPlaylistListState createState() => _PrintPlaylistListState();
}

class _PrintPlaylistListState extends State<PrintPlaylistList> {
  final dbPlaylists = PlaylistDao.instance;
  bool loading = true;
  String formattedList = '';

  @override
  void initState() {
    super.initState();
    getPlaylists();
  }

  void getPlaylists() async {
    List<Map<String, dynamic>> listPlaylistsListen =
    await dbPlaylists.queryAllRowsDescState(0);
    List<Map<String, dynamic>> listPlaylistArchive =
    await dbPlaylists.queryAllRowsDescState(1);
    List<Map<String, dynamic>> listPlaylistFavorites =
    await dbPlaylists.queryAllRowsDescState(2);

    formattedList +=
    'LISTEN - ${listPlaylistsListen.length} Playlists\n';
    for (int i = 0; i < listPlaylistsListen.length; i++) {
      formattedList += "\n• ${listPlaylistsListen[i]['title']}\n";
      formattedList += listPlaylistsListen[i]['link'] + "\n";
    }
    formattedList += '\n********************\n\n';
    formattedList += 'ARCHIVE - ${listPlaylistArchive.length} Playlists\n';
    for (int i = 0; i < listPlaylistArchive.length; i++) {
      formattedList += "\n• ${listPlaylistArchive[i]['title']}\n";
      formattedList += listPlaylistArchive[i]['link'] + "\n";
    }
    formattedList += '\n********************\n\n';
    formattedList += 'FAVORITES - ${listPlaylistFavorites.length} Playlists\n';
    for (int i = 0; i < listPlaylistFavorites.length; i++) {
      formattedList += "\n• ${listPlaylistFavorites[i]['title']}\n";
      formattedList += listPlaylistFavorites[i]['link'] + "\n";
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print playlists'),
        actions: [
          TextButton(
            child: const Text(
              "Copy",
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formattedList));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        children: [
          (loading)
              ? const SizedBox.shrink()
              : SelectableText(
            formattedList,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}

