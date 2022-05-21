import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:spotify_metadata/spotify_metadata.dart';
import 'package:web_scraper/web_scraper.dart';
import '../app.dart';
import '../db/playlists_tags_dao.dart';
import '../db/tag_dao.dart';

class ShareSavePlaylist extends StatefulWidget {
  @override
  _ShareSavePlaylistState createState() => _ShareSavePlaylistState();

  String? sharedText = "";

  ShareSavePlaylist({Key? key, this.sharedText}) : super(key: key);
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
          webScraper.getElement('head > meta:nth-child(6)', ['content']);
      List<String> artistDataElement =
          elements[0]['attributes']['content'].toString().split('·');
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
    final Color? bottomOverlayColor =
        Theme.of(context).bottomNavigationBarTheme.backgroundColor;
    final Color? topOverlayColor =
        Theme.of(context).appBarTheme.backgroundColor;
    final Brightness iconBrightness =
        Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: iconBrightness,
        systemNavigationBarColor: bottomOverlayColor,
        statusBarColor: topOverlayColor,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarIconBrightness: iconBrightness,
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            _loseFocus();
          },
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
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(Icons.save_outlined),
                    tooltip: 'Save',
                    onPressed: () {
                      if (checkErrors().isEmpty) {
                        _savePlaylist().then((v) => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const App()),
                                  ModalRoute.withName('/'))
                            });
                      } else {
                        showAlertDialogErrors(context);
                      }
                    },
                  ),
                ],
              ),
              body: ListView(children: [
                ListTile(
                  title: Text("Cover",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary)),
                ),
                ListTile(
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    maxLines: 4,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    minLines: 1,
                    maxLines: 3,
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
                          children: List<Widget>.generate(tagsList.length,
                              (int index) {
                            return ChoiceChip(
                              key: UniqueKey(),
                              selected: false,
                              onSelected: (bool _selected) {
                                if (selectedTags
                                    .contains(tagsList[index]['id_tag'])) {
                                  selectedTags
                                      .remove(tagsList[index]['id_tag']);
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank_outlined,
                                      size: 20,
                                    ),
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color: selectedTags
                                          .contains(tagsList[index]['id_tag'])
                                          ?  Theme.of(context).colorScheme.primary
                                          : Colors.grey.shade800.withOpacity(0.4))),
                              label: Text(tagsList[index]['name']),
                              labelPadding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
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
        ),
      ),
    );
  }
}
