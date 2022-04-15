import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:spotify_metadata/spotify_metadata.dart';

class SavePlaylist extends StatefulWidget {
  @override
  _SavePlaylistState createState() => _SavePlaylistState();

  SavePlaylist({Key? key}) : super(key: key);
}

class _SavePlaylistState extends State<SavePlaylist> {
  final dbPlaylist = PlaylistDao.instance;
  TextEditingController controllerPlaylistTitle = TextEditingController();
  TextEditingController controllerArtist = TextEditingController();
  TextEditingController controllerLink = TextEditingController();
  static SpotifyMetadata? metaData;


  //File? capa;
  String base64Image = '';


  void _fetchMetadata(String link) async {
    try {
      metaData = await SpotifyApi.getData(link);
    } catch (e) {
      metaData = null;
    }
    setState(() {
      metaData;
      controllerPlaylistTitle.text = metaData!.title;
    });
  }


  void _savePlaylist() async {

    http.Response response = await http.get(Uri.parse(
        metaData!.thumbnailUrl));
    base64Image = base64Encode(response.bodyBytes);
    Uint8List bytes = base64Decode(base64Image);

    Map<String, dynamic> row = {
      PlaylistDao.columnLink: controllerLink.text,
      PlaylistDao.columnTitle: controllerPlaylistTitle.text,
      PlaylistDao.columnArtist: controllerArtist.text,
      PlaylistDao.columnCover: base64Image.isEmpty ? null : bytes,
    };
    final id = await dbPlaylist.insert(row);
  }

  String checkErrors() {
    String erros = "";
    if (controllerLink.text.isEmpty) {
      erros += "Insert link\n";
    }
    if (controllerPlaylistTitle.text.isEmpty) {
      erros += "Insert title\n";
    }
    return erros;
  }

  showAlertDialogErrors(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Error",
          ),
          content: Text(
            checkErrors(),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Ok",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Save Playlist'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              tooltip: 'Load data',
              onPressed: () {
                _fetchMetadata(controllerLink.text);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save',
              onPressed: () {
                if (checkErrors().isEmpty) {
                  _savePlaylist();
                  Navigator.of(context).pop();
                } else {
                  showAlertDialogErrors(context);
                }
              },
            ),
          ],
        ),
        body: ListView(children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0,
                  child: metaData == null
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          width: 125,
                          height: 125,
                          child: const Center(
                            child: Icon(
                              Icons.music_note_outlined,
                              size: 30,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            metaData!.thumbnailUrl,
                            width: 125,
                            height: 125,
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
              ]),
            ),
          ),
          ListTile(
            title: Text("Link",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            title: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: controllerLink,
              onEditingComplete: () => node.nextFocus(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.notes_outlined),
                helperText: "* Required",
                counterText: "",
              ),
            ),
          ),
          ListTile(
            title: Text("Title",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            title: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 300,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: controllerPlaylistTitle,
              onEditingComplete: () => node.nextFocus(),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.notes_outlined),
                helperText: "* Required",
                counterText: "",
              ),
            ),
          ),
          ListTile(
            title: Text("Artist",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          ListTile(
            title: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 300,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: controllerArtist,
              onEditingComplete: () => node.nextFocus(),
              decoration: const InputDecoration(
                counterText: "",
                prefixIcon: Icon(
                  Icons.person_outline_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
        ]));
  }
}
