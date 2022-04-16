import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:spotify_metadata/spotify_metadata.dart';

import '../class/playlist.dart';

class SavePlaylist extends StatefulWidget {
  @override
  _SavePlaylistState createState() => _SavePlaylistState();

  Function() refreshHome;
  Playlist? playlist;

  SavePlaylist({Key? key, required this.refreshHome, this.playlist}) : super(key: key);
}

class _SavePlaylistState extends State<SavePlaylist> {
  final dbPlaylist = PlaylistDao.instance;
  TextEditingController controllerPlaylistTitle = TextEditingController();
  TextEditingController controllerArtist = TextEditingController();
  TextEditingController controllerTags = TextEditingController();
  TextEditingController controllerLink = TextEditingController();
  static SpotifyMetadata? metaData;
  String base64Image = '';

  void _fetchMetadata() async {
    try {
      metaData = await SpotifyApi.getData(controllerLink.text);
    } catch (e) {
      metaData = null;
    }
    setState(() {
      metaData;
      controllerPlaylistTitle.text = metaData!.title;
    });
  }


  Future<void> _updatePlaylist() async {

    /* Map<String, dynamic> row = {
      TaskDao.columnId: widget.task.id,
      TaskDao.columnTitle: customControllerTitle.text,
      TaskDao.columnNote: customControllerNote.text,
    };
    final update = await tasks.update(row);*/

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

  void _loseFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _loseFocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Playlist'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_outlined),
                tooltip: 'Load data',
                onPressed: () {
                  _fetchMetadata();
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
                    _updatePlaylist().then((v) => {
                      widget.refreshHome(),
                      Navigator.of(context).pop()
                    }
                    );
                  } else {
                    showAlertDialogErrors(context);
                  }
                },
              ),
            ],
          ),
          body: ListView(
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                fit: BoxFit.cover,
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
                    onSubmitted: (e) => _fetchMetadata(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.link_outlined),
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
                    decoration: const InputDecoration(
                      counterText: "",
                      prefixIcon: Icon(
                        Icons.person_outline_outlined,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Tags",
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
                    controller: controllerTags,
                    decoration: const InputDecoration(
                      counterText: "",
                      prefixIcon: Icon(
                        Icons.sell_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ])),
    );
  }
}
