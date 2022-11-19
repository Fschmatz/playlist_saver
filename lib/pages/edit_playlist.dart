import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import '../class/playlist.dart';
import '../db/playlists_tags_dao.dart';
import '../db/tag_dao.dart';
import '../util/utils_functions.dart';

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
    super.initState();
    controllerLink.text = widget.playlist.link;
    controllerPlaylistTitle.text = widget.playlist.title;
    controllerArtist.text = widget.playlist.artist!;
    getAllTags().then((value) => getTagsFromTask());
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
    bool ok = true;
    if (controllerLink.text.isEmpty) {
      ok = false;
      _validLink = false;
    }
    if (controllerPlaylistTitle.text.isEmpty) {
      ok = false;
      _validTitle = false;
    }
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    final Brightness tagTextBrightness = Theme.of(context).brightness;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit playlist'),
          /*actions: [
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
          ],*/
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            padding: const EdgeInsets.fromLTRB(18, 5, 25, 0),
            child: Text(
              "Add tags",
              style:
                  TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
            ),
          ),
          (tagsList.isEmpty)
              ? const SizedBox.shrink()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Wrap(
                    spacing: 8.0,
                    children:
                        List<Widget>.generate(tagsList.length, (int index) {
                      return FilterChip(
                        key: UniqueKey(),
                        onSelected: (bool selected) {
                          if (selectedTags
                              .contains(tagsList[index]['id_tag'])) {
                            selectedTags.remove(tagsList[index]['id_tag']);
                          } else {
                            selectedTags.add(tagsList[index]['id_tag']);
                          }
                          setState(() {});
                        },
                        side: BorderSide(
                            color: selectedTags
                                    .contains(tagsList[index]['id_tag'])
                                ? tagTextBrightness == Brightness.dark
                                    ? darkenColor(
                                        Theme.of(context).colorScheme.primary,
                                        65)
                                    : lightenColor(
                                        Theme.of(context).colorScheme.primary,
                                        70)
                                : Theme.of(context)
                                    .inputDecorationTheme
                                    .border!
                                    .borderSide
                                    .color
                                    .withOpacity(0.3)),
                        label: Text(
                          tagsList[index]['name'],
                        ),
                        backgroundColor: selectedTags
                                .contains(tagsList[index]['id_tag'])
                            ? tagTextBrightness == Brightness.dark
                                ? darkenColor(
                                    Theme.of(context).colorScheme.primary, 65)
                                : lightenColor(
                                    Theme.of(context).colorScheme.primary, 70)
                            : Theme.of(context).scaffoldBackgroundColor,
                        labelStyle: TextStyle(
                            color:
                                selectedTags.contains(tagsList[index]['id_tag'])
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .color!
                                        .withOpacity(0.9)),
                      );
                    }).toList(),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)))),
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
                child: Text(
                  'Save playlist',
                  style:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )),
          ),
          const SizedBox(
            height: 50,
          ),
        ]));
  }
}
