import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/class/init_data.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:spotify_metadata/spotify_metadata.dart';
import 'package:web_scraper/web_scraper.dart';
import '../app.dart';
import '../db/playlists_tags_dao.dart';
import '../db/tag_dao.dart';
import '../main.dart';
import '../start_app_routes.dart';
import '../util/utils_functions.dart';

class ShareSavePlaylist extends StatefulWidget {
  @override
  _ShareSavePlaylistState createState() => _ShareSavePlaylistState();

  String? sharedText = "";

  ShareSavePlaylist({Key? key, this.sharedText})
      : super(key: key);
}

class _ShareSavePlaylistState extends State<ShareSavePlaylist> {
  TextEditingController controllerPlaylistTitle = TextEditingController();
  TextEditingController controllerArtist = TextEditingController();
  TextEditingController controllerTags = TextEditingController();
  TextEditingController controllerLink = TextEditingController();
  SpotifyMetadata? metaData;
  String base64Image = '';
  final tags = TagDao.instance;
  final playlistsTags = PlaylistsTagsDao.instance;
  bool loadingTags = true;
  List<Map<String, dynamic>> tagsList = [];
  List<int> selectedTags = [];
  bool _validTitle = true;
  bool _validLink = true;

  @override
  void initState() {
    controllerLink.text = widget.sharedText!;
    getAllTags();
    _fetchMetadata();
    super.initState();
  }

  Future<void> getAllTags() async {
    var resp = await tags.queryAllRowsByName();
    setState(() {
      tagsList = resp;
      loadingTags = false;
    });
  }

  void _fetchMetadata() async {
    String artistName = await parseArtistName();
    try {
      metaData = await SpotifyApi.getData(controllerLink.text);
    } catch (e) {
      metaData = null;
      Fluttertoast.showToast(
        msg: "Error parsing data",
      );
    }
    if (mounted) {
      setState(() {
        metaData;
        controllerPlaylistTitle.text = metaData!.title;
        controllerArtist.text = artistName;
      });
    }
  }

  Future<String> parseArtistName() async {
    final webScraper = WebScraper();
    if (await webScraper.loadFullURL(controllerLink.text)) {
      List<Map<String, dynamic>> elements =
          webScraper.getElement('head > meta:nth-child(6)', ['content']);
      List<String> artistDataElement =
          elements[0]['attributes']['content'].toString().split('??');
      return artistDataElement[0].trim();
    } else {
      return '';
    }
  }

  Future<void> _savePlaylist() async {
    final dbPlaylist = PlaylistDao.instance;
    Uint8List? bytes;

    if (metaData != null) {
      http.Response response =
          await http.get(Uri.parse(metaData!.thumbnailUrl));
      base64Image = base64Encode(response.bodyBytes);
      bytes = base64Decode(base64Image);
    }

    Map<String, dynamic> row = {
      PlaylistDao.columnLink: controllerLink.text,
      PlaylistDao.columnTitle: controllerPlaylistTitle.text,
      PlaylistDao.columnArchived: 0,
      PlaylistDao.columnArtist: controllerArtist.text,
      PlaylistDao.columnCover: base64Image.isEmpty ? null : bytes,
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
    final Color? bottomOverlayColor =
        Theme.of(context).bottomNavigationBarTheme.backgroundColor;
    final Color? topOverlayColor =
        Theme.of(context).appBarTheme.backgroundColor;
    final Brightness iconBrightness =
        Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light;

    final Brightness tagTextBrightness = Theme.of(context).brightness;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: iconBrightness,
        systemNavigationBarColor: bottomOverlayColor,
        statusBarColor: topOverlayColor,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarIconBrightness: iconBrightness,
      ),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Save Shared Playlist'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Load data',
                  onPressed: () {
                    _fetchMetadata();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  tooltip: 'Save',
                  onPressed: () {
                    if (validateTextFields()) {
                      _savePlaylist().then((v) => {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                         StartAppRoutes(
                                          initData: InitData("", homeRoute),
                                        )),
                                (route) => false)
                          });
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
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
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
                      errorText: _validLink ? null : "Link is empty"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      errorText: _validTitle ? null : "Title is empty"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 5, 25, 0),
                child: Text(
                  "Add tags",
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).hintColor),
                ),
              ),
              (tagsList.isEmpty)
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Wrap(
                        spacing: 8.0,
                        children:
                            List<Widget>.generate(tagsList.length, (int index) {
                          return FilterChip(
                            key: UniqueKey(),
                            selected: false,
                            onSelected: (bool selected) {
                              if (selectedTags
                                  .contains(tagsList[index]['id_tag'])) {
                                selectedTags.remove(tagsList[index]['id_tag']);
                              } else {
                                selectedTags.add(tagsList[index]['id_tag']);
                              }
                              setState(() {});
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
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
                                            .withOpacity(0.3))),
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
                                    : Theme.of(context).textTheme.headline6!.color!.withOpacity(0.9)),
                          );
                        }).toList(),
                      ),
                    ),
              const SizedBox(
                height: 50,
              ),
            ])),
      ),
    );
  }
}
