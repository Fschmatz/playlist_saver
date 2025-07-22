import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:playlist_saver/service/spotify_metadata_service.dart';

import '../class/spotify_metadata.dart';
import '../service/playlist_service.dart';

class SavePlaylist extends StatefulWidget {
  @override
  State<SavePlaylist> createState() => _SavePlaylistState();

  const SavePlaylist({super.key});
}

class _SavePlaylistState extends State<SavePlaylist> {
  TextEditingController controllerPlaylistTitle = TextEditingController();
  TextEditingController controllerArtist = TextEditingController();
  TextEditingController controllerLink = TextEditingController();
  SpotifyMetadata? metaData;
  bool _validTitle = true;
  bool _validLink = true;
  bool _downloaded = false;
  bool _newAlbum = false;

  void _fetchMetadata() async {
    try {
      metaData = await SpotifyMetadataService().loadMetadata(controllerLink.text);
    } catch (e) {
      metaData = null;
      Fluttertoast.showToast(
        msg: "Error parsing data",
      );
    }

    setState(() {
      metaData;
      controllerPlaylistTitle.text = metaData!.title;
      controllerArtist.text = metaData!.artistName!;
    });
  }

  Future<void> _savePlaylist() async {
    Uint8List? compressedCover;

    if (metaData != null) {
      http.Response response = await http.get(Uri.parse(metaData!.imageUrl));
      compressedCover = await SpotifyMetadataService().compressCoverImage(response.bodyBytes);
    }

    await PlaylistService()
        .insertPlaylist(compressedCover, controllerLink.text, controllerPlaylistTitle.text, controllerArtist.text, _downloaded, _newAlbum);
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('New playlist'),
        ),
        body: ListView(children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: metaData == null
                    ? Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
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
                          metaData!.imageUrl,
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
                  border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
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
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text(
              "Downloaded",
            ),
            subtitle: const Text(
              "Downloaded to device",
            ),
            value: _downloaded,
            onChanged: (value) {
              setState(() {
                _downloaded = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text(
              "New album",
            ),
            subtitle: const Text(
              "Highlight as new",
            ),
            value: _newAlbum,
            onChanged: (value) {
              setState(() {
                _newAlbum = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: FilledButton.tonalIcon(
                onPressed: () {
                  if (validateTextFields()) {
                    _savePlaylist();
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _validLink;
                      _validTitle;
                    });
                  }
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Save',
                )),
          ),
          const SizedBox(
            height: 50,
          ),
        ]));
  }
}
