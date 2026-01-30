import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:playlist_saver/service/spotify_metadata_service.dart';

import '../class/spotify_metadata.dart';
import '../service/playlist_service.dart';
import '../widgets/playlist_artwork.dart';
import '../widgets/playlist_form.dart';

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
    return PlaylistForm(
      appBarTitle: 'New playlist',
      linkController: controllerLink,
      titleController: controllerPlaylistTitle,
      artistController: controllerArtist,
      validLink: _validLink,
      validTitle: _validTitle,
      downloaded: _downloaded,
      newAlbum: _newAlbum,
      isUpdate: false,
      artwork: PlaylistArtwork(
        imageUrl: metaData?.imageUrl,
      ),
      onLinkSubmitted: _fetchMetadata,
      onDownloadedChanged: (v) => setState(() => _downloaded = v),
      onNewAlbumChanged: (v) => setState(() => _newAlbum = v),
      onSave: () {
        if (validateTextFields()) {
          _savePlaylist();
          Navigator.pop(context);
        } else {
          setState(() {});
        }
      },
    );
  }
}
