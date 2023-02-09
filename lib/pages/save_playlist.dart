import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:spotify_metadata/spotify_metadata.dart';
import 'package:web_scraper/web_scraper.dart';
import '../db/tag_dao.dart';
import '../db/playlists_tags_dao.dart';
import '../util/utils_functions.dart';

class SavePlaylist extends StatefulWidget {
  @override
  _SavePlaylistState createState() => _SavePlaylistState();

  Function()? refreshHome;

  SavePlaylist({Key? key, required this.refreshHome}) : super(key: key);
}

class _SavePlaylistState extends State<SavePlaylist> {
  TextEditingController controllerPlaylistTitle = TextEditingController();
  TextEditingController controllerArtist = TextEditingController();
  TextEditingController controllerTags = TextEditingController();
  TextEditingController controllerLink = TextEditingController();
  SpotifyMetadata? metaData;
  final tags = TagDao.instance;
  final playlistsTags = PlaylistsTagsDao.instance;
  bool loadingTags = true;
  List<Map<String, dynamic>> tagsList = [];
  List<int> selectedTags = [];
  bool _validTitle = true;
  bool _validLink = true;
  bool _downloaded = false;

  @override
  void initState() {
    super.initState();
    getAllTags();
  }

  Future<void> getAllTags() async {
    var resp = await tags.queryAllRowsByName();
    tagsList = resp;

    setState(() {
      loadingTags = false;
    });
  }

  void _fetchMetadata() async {
    String artistName = "";

    try {
      metaData = await SpotifyApi.getData(controllerLink.text);
    } catch (e) {
      metaData = null;
      Fluttertoast.showToast(
        msg: "Error parsing data",
      );
    }

    try {
      artistName = await parseArtistName();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error parsing artist name",
      );
    }

    setState(() {
      metaData;
      controllerPlaylistTitle.text = metaData!.title;
      controllerArtist.text = artistName;
    });
  }

  Future<String> parseArtistName() async {
    final webScraper = WebScraper();
    if (await webScraper.loadFullURL(controllerLink.text)) {
      List<Map<String, dynamic>> elements =
          webScraper.getElement('head > title', ['content']);
      String artistDataElement = elements[0]['title'];

      return formatArtistNameToSave(artistDataElement);
    } else {
      return '';
    }
  }

  Future<void> _savePlaylist() async {
    final dbPlaylist = PlaylistDao.instance;
    Uint8List? base64ImageBytes;
    Uint8List? compressedCover;

    if (metaData != null) {
      http.Response response =
          await http.get(Uri.parse(metaData!.thumbnailUrl));
      base64ImageBytes = response.bodyBytes;
      compressedCover = await compressCoverImage(base64ImageBytes);
    }

    Map<String, dynamic> row = {
      PlaylistDao.columnLink: controllerLink.text,
      PlaylistDao.columnTitle: controllerPlaylistTitle.text,
      PlaylistDao.columnState: 0,
      PlaylistDao.columnArtist: controllerArtist.text,
      PlaylistDao.columnDownloaded: _downloaded ? 1 : 0,
      PlaylistDao.columnCover:
          compressedCover!.isEmpty ? null : compressedCover,
    };
    final idPlaylist = await dbPlaylist.insert(row);

    if (selectedTags.isNotEmpty) {
      for (int i = 0; i < selectedTags.length; i++) {
        Map<String, dynamic> rowsTaskTags = {
          PlaylistsTagsDao.columnIdPlaylist: idPlaylist,
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
          title: const Text('New playlist'),
        ),
        body: ListView(children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: controllerLink,
              onSubmitted: (e) => _fetchMetadata(),
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
          SwitchListTile(
            title: const Text(
              "Downloaded",
            ),
            value: _downloaded,
            onChanged: (value) {
              setState(() {
                _downloaded = value;
              });
            },
          ),
          const ListTile(
            title: Text(
              "Add Tags",
            ),
          ),
          loadingTags
              ? const SizedBox.shrink()
              : (tagsList.isEmpty)
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
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
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            65)
                                        : lightenColor(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
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
                                        Theme.of(context).colorScheme.primary,
                                        65)
                                    : lightenColor(
                                        Theme.of(context).colorScheme.primary,
                                        70)
                                : Theme.of(context).scaffoldBackgroundColor,
                            labelStyle: TextStyle(
                                color: selectedTags
                                        .contains(tagsList[index]['id_tag'])
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
          loadingTags
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: FilledButton.tonalIcon(
                      onPressed: () {
                        if (validateTextFields()) {
                          _savePlaylist().then((v) => {
                                widget.refreshHome!(),
                                Navigator.of(context).pop(),
                              });
                        } else {
                          setState(() {
                            _validLink;
                            _validTitle;
                          });
                        }
                      },
                      icon: Icon(Icons.save_outlined,
                          color: Theme.of(context).colorScheme.onPrimary),
                      label: Text(
                        'Save',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )),
                ),
          const SizedBox(
            height: 50,
          ),
        ]));
  }
}
