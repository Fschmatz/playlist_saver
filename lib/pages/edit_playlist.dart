import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../class/playlist.dart';
import '../service/playlist_service.dart';

class EditPlaylist extends StatefulWidget {
  @override
  State<EditPlaylist> createState() => _EditPlaylistState();

  final Function() refreshHome;
  final Playlist playlist;

  const EditPlaylist({super.key, required this.refreshHome, required this.playlist});
}

class _EditPlaylistState extends State<EditPlaylist> {

  TextEditingController controllerPlaylistTitle = TextEditingController();
  TextEditingController controllerArtist = TextEditingController();
  TextEditingController controllerLink = TextEditingController();
  bool _validTitle = true;
  bool _validLink = true;
  bool _downloaded = false;
  bool _newAlbum = false;

  @override
  void initState() {
    super.initState();

    controllerLink.text = widget.playlist.link;
    controllerPlaylistTitle.text = widget.playlist.title;
    controllerArtist.text = widget.playlist.artist!;
    _downloaded = widget.playlist.isDownloaded();
    _newAlbum = widget.playlist.isNewAlbum();
  }

  Future<void> _updatePlaylist() async {
    await PlaylistService()
        .updatePlaylist(widget.playlist.idPlaylist, controllerLink.text, controllerPlaylistTitle.text, controllerArtist.text, _downloaded, _newAlbum);
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
          title: const Text('Edit playlist'),
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
                    _updatePlaylist().then((v) => {widget.refreshHome(), Navigator.of(context).pop()});
                  } else {
                    setState(() {
                      _validLink;
                      _validTitle;
                    });
                  }
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save')),
          ),
          const SizedBox(
            height: 50,
          ),
        ]));
  }
}
