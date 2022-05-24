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
  bool _validTitle = true;
  bool _validLink = true;

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

  bool validateTextFields() {
    String errors = "";
    if (controllerLink.text.isEmpty) {
      errors += "Link";
      _validLink = false;
    }
    if (controllerPlaylistTitle.text.isEmpty) {
      errors += "Title";
      _validTitle = false;
    }
    return errors.isEmpty ? true : false;
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
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save',
                onPressed: () {
                  if (validateTextFields()) {
                    _updatePlaylist().then((v) =>
                        {widget.refreshHome(), Navigator.of(context).pop()});
                  } else {
                    setState(() {
                      _validLink;
                      _validTitle;
                    });
                  }
                },
              ),
            ],
          ),
          body: ListView(children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                minLines: 1,
                maxLines: 4,
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                controller: controllerLink,
                decoration: InputDecoration(
                    labelText: "Link",
                    helperText: "* Required",
                    counterText: "",
                    errorText: (_validLink) ? null : "Link is empty"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                minLines: 1,
                maxLines: 3,
                maxLength: 300,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                controller: controllerPlaylistTitle,
                decoration: InputDecoration(
                    labelText: "Title",
                    helperText: "* Required",
                    counterText: "",
                    errorText: (_validTitle) ? null : "Title is empty"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                minLines: 1,
                maxLines: 2,
                maxLength: 300,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                controller: controllerArtist,
                decoration: const InputDecoration(
                  labelText: "Artist",
                  counterText: "",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 5),
              child: Text(
                'Tags',
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.headline1!.color),
              ),
            ),
            (tagsList.isEmpty)
                ? const SizedBox.shrink()
                : Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12.0,
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
                    avatar: selectedTags
                        .contains(tagsList[index]['id_tag'])
                        ? Icon(
                      Icons.check_box_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    )
                        : const Icon(
                      Icons.check_box_outline_blank_outlined,
                      size: 20,
                    ),
                    shape: StadiumBorder(
                        side: BorderSide(
                            color: selectedTags
                                .contains(tagsList[index]['id_tag'])
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade800.withOpacity(0.4))),
                    label: Text(
                      tagsList[index]['name'],
                    ),
                    labelPadding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: selectedTags
                            .contains(tagsList[index]['id_tag'])
                            ? Theme.of(context).colorScheme.primary
                            : null),
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
