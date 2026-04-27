import 'package:flutter/material.dart';

import '../class/playlist.dart';
import '../service/playlist_service.dart';
import '../widgets/playlist_form.dart';

class EditPlaylist extends StatefulWidget {
  @override
  State<EditPlaylist> createState() => _EditPlaylistState();

  final Playlist playlist;

  const EditPlaylist({super.key, required this.playlist});
}

class _EditPlaylistState extends State<EditPlaylist> {
  final TextEditingController _controllerPlaylistTitle = TextEditingController();
  final TextEditingController _controllerArtist = TextEditingController();
  final TextEditingController _controllerLink = TextEditingController();
  bool _validTitle = true;
  bool _validLink = true;
  bool _downloaded = false;
  bool _newAlbum = false;

  @override
  void initState() {
    super.initState();

    _controllerLink.text = widget.playlist.link;
    _controllerPlaylistTitle.text = widget.playlist.title;
    _controllerArtist.text = widget.playlist.artist!;
    _downloaded = widget.playlist.isDownloaded();
    _newAlbum = widget.playlist.isNewAlbum();
  }

  Future<void> _updatePlaylist() async {
    Playlist updatedPlaylist = widget.playlist.copyWith(
      link: _controllerLink.text,
      title: _controllerPlaylistTitle.text,
      artist: _controllerArtist.text,
      downloaded: _downloaded ? 1 : 0,
      newAlbum: _newAlbum ? 1 : 0,
    );

    await PlaylistService().updatePlaylist(updatedPlaylist);
  }

  bool validateTextFields() {
    bool ok = true;
    if (_controllerLink.text.isEmpty) {
      ok = false;
      _validLink = false;
    }

    if (_controllerPlaylistTitle.text.isEmpty) {
      ok = false;
      _validTitle = false;
    }

    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return PlaylistForm(
      appBarTitle: 'Edit playlist',
      linkController: _controllerLink,
      titleController: _controllerPlaylistTitle,
      artistController: _controllerArtist,
      validLink: _validLink,
      validTitle: _validTitle,
      downloaded: _downloaded,
      newAlbum: _newAlbum,
      isUpdate: true,
      onDownloadedChanged: (v) => setState(() => _downloaded = v),
      onNewAlbumChanged: (v) => setState(() => _newAlbum = v),
      onSave: () {
        if (validateTextFields()) {
          _updatePlaylist();
          Navigator.pop(context);
        } else {
          setState(() {});
        }
      },
    );
  }
}
