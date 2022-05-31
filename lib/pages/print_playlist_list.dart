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
    getPlaylists();
    super.initState();
  }

  void getPlaylists() async {
    List<Map<String, dynamic>> _listPlaylistsListen =
        await dbPlaylists.queryAllRowsDescArchive(0);
    List<Map<String, dynamic>> _listPlaylistArchive =
        await dbPlaylists.queryAllRowsDescArchive(1);

    formattedList +=
        'LISTEN - ' + _listPlaylistsListen.length.toString() + ' Playlists\n';
    for (int i = 0; i < _listPlaylistsListen.length; i++) {
      formattedList += "\n• " + _listPlaylistsListen[i]['title'] + "\n";
      formattedList += _listPlaylistsListen[i]['link'] + "\n";
    }
    formattedList += '\n\nARCHIVE - ' +
        _listPlaylistArchive.length.toString() +
        ' Playlists\n';
    for (int i = 0; i < _listPlaylistArchive.length; i++) {
      formattedList += "\n• " + _listPlaylistArchive[i]['title'] + "\n";
      formattedList += _listPlaylistArchive[i]['link'] + "\n";
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Playlists'),
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
