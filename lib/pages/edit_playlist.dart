import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:spotify_metadata/spotify_metadata.dart';
import '../class/playlist.dart';
import '../db/playlists_tags_dao.dart';
import '../db/tag_dao.dart';

class EditPlaylist extends StatefulWidget {
  @override
  _EditPlaylistState createState() => _EditPlaylistState();

  Function() refreshHome;
  Playlist playlist;

  EditPlaylist({Key? key, required this.refreshHome, required this.playlist})
      : super(key: key);
}

class _EditPlaylistState extends State<EditPlaylist> {
  TextEditingController controllerPlaylistTitle = TextEditingController();
  TextEditingController controllerArtist = TextEditingController();
  TextEditingController controllerTags = TextEditingController();
  TextEditingController controllerLink = TextEditingController();
  String base64Image = '';
  final tags = TagDao.instance;
  final playlistsTags = PlaylistsTagsDao.instance;
  bool loadingTags = true;
  List<Map<String, dynamic>> tagsList = [];
  List<int> selectedTags = [];
  List<int> tagsFromDbTask = [];

  @override
  void initState() {
    controllerLink.text = widget.playlist.link;
    controllerPlaylistTitle.text = widget.playlist.title;
    controllerArtist.text = widget.playlist.artist!;
    getAllTags().then((value) => getTagsFromTask());
    super.initState();
  }

  Future<void> getAllTags() async {
    var resp = await tags.queryAllRowsByName();
    setState(() {
      tagsList = resp;
      loadingTags = false;
    });
  }

  void getTagsFromTask() async {
    var resp =
        await playlistsTags.queryTagsFromTaskId(widget.playlist.idPlaylist);
    for (int i = 0; i < resp.length; i++) {
      tagsFromDbTask.add(resp[i]['id_tag']);
    }

    setState(() {
      selectedTags = tagsFromDbTask;
      loadingTags = false;
    });
  }

  Future<void> _updatePlaylist() async {
    final deletedTaskTag =
        await playlistsTags.delete(widget.playlist.idPlaylist);
    final dbPlaylist = PlaylistDao.instance;

    Map<String, dynamic> row = {
      PlaylistDao.columnIdPlaylist: widget.playlist.idPlaylist,
      PlaylistDao.columnLink: controllerLink.text,
      PlaylistDao.columnTitle: controllerPlaylistTitle.text,
      PlaylistDao.columnArtist: controllerArtist.text,
    };
    final update = await dbPlaylist.update(row);

    if (selectedTags.isNotEmpty) {
      for (int i = 0; i < selectedTags.length; i++) {
        Map<String, dynamic> rowsTaskTags = {
          PlaylistsTagsDao.columnIdPlaylist: widget.playlist.idPlaylist,
          PlaylistsTagsDao.columnIdTag: selectedTags[i],
        };
        final idsPlaylistsTags = await playlistsTags.insert(rowsTaskTags);
      }
    }
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
              /*IconButton(
                icon: const Icon(Icons.refresh_outlined),
                tooltip: 'Load data',
                onPressed: () {
                  _fetchMetadata();
                },
              ),
              const SizedBox(
                width: 10,
              ),*/
              IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () {
                  if (checkErrors().isEmpty) {
                    _updatePlaylist().then((v) =>
                        {widget.refreshHome(), Navigator.of(context).pop()});
                  } else {
                    showAlertDialogErrors(context);
                  }
                },
              ),
            ],
          ),
          body: ListView(children: [
            /*  ListTile(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                    child: metaData == null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6)),
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
                            borderRadius: BorderRadius.circular(6),
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
            ),*/
            ListTile(
              title: Text("Link",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                minLines: 1,
                maxLines: 2,
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                controller: controllerLink,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
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
              title: tagsList.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                      spacing: 10.0,
                      runSpacing: 12.0,
                      children:
                          List<Widget>.generate(tagsList.length, (int index) {
                        return ChoiceChip(
                          key: UniqueKey(),
                          selected: false,
                          onSelected: (bool _selected) {
                            if (selectedTags
                                .contains(tagsList[index]['id_tag'])) {
                              selectedTags.remove(tagsList[index]['id_tag']);
                            } else {
                              selectedTags.add(tagsList[index]['id_tag']);
                            }
                            setState(() {});
                          },
                          avatar:
                              selectedTags.contains(tagsList[index]['id_tag'])
                                  ? const Icon(
                                      Icons.check_box_outlined,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank_outlined,
                                      size: 20,
                                    ),
                          elevation: 0,
                          shape: StadiumBorder(
                              side: BorderSide(color: Colors.grey.shade800.withOpacity(0.3))),
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                            child: Text(tagsList[index]['name']),
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(
              height: 50,
            ),
          ])),
    );
  }
}
