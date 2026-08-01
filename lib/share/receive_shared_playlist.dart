import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../class/spotify_metadata.dart';
import '../redux/actions.dart';
import '../service/spotify_metadata_service.dart';
import '../util/toast_utils.dart';
import '../widgets/playlist_artwork.dart';
import '../widgets/playlist_form.dart';

class ReceiveSharedPlaylist extends StatefulWidget {
  @override
  State<ReceiveSharedPlaylist> createState() => _ReceiveSharedPlaylistState();

  String? sharedText = "";

  ReceiveSharedPlaylist({super.key, this.sharedText});
}

class _ReceiveSharedPlaylistState extends State<ReceiveSharedPlaylist> {
  final TextEditingController _controllerPlaylistTitle = TextEditingController();
  final TextEditingController _controllerArtist = TextEditingController();
  final TextEditingController _controllerLink = TextEditingController();
  SpotifyMetadata? metaData;
  bool _validTitle = true;
  bool _validLink = true;
  bool _downloaded = false;
  bool _newAlbum = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    startFunctions();
  }

  void startFunctions() {
    List<String> formattedString = widget.sharedText!.split('https');

    _controllerLink.text = "https${formattedString[1]}";
    _fetchMetadata();
  }

  void _fetchMetadata() async {
    setState(() {
      _isLoading = true;
    });

    try {
      metaData = await SpotifyMetadataService().loadMetadata(_controllerLink.text);
    } catch (e) {
      metaData = null;
      ToastUtils.showErrorMessage(
        "Error parsing data",
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        metaData;
        if (metaData != null) {
          _controllerPlaylistTitle.text = SpotifyMetadataService().formatTitleToSave(metaData!.title);
          _controllerArtist.text = metaData!.artistName!;
        }
      });
    }
  }

  Future<void> _savePlaylist() async {
    await context.dispatchAndWait(AddPlaylistAction(
      metadata: metaData,
      title: _controllerPlaylistTitle.text,
      artist: _controllerArtist.text,
      link: _controllerLink.text,
      downloaded: _downloaded,
      newAlbum: _newAlbum,
    ));
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
    final theme = Theme.of(context);
    final Color topOverlayColor = theme.colorScheme.surface;
    final Brightness iconBrightness = theme.brightness == Brightness.light ? Brightness.dark : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: iconBrightness,
        statusBarColor: topOverlayColor,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarIconBrightness: iconBrightness,
      ),
      child: PlaylistForm(
        appBarTitle: 'New playlist',
        showLinkField: false,
        linkController: _controllerLink,
        titleController: _controllerPlaylistTitle,
        artistController: _controllerArtist,
        validLink: true,
        validTitle: _validTitle,
        downloaded: _downloaded,
        newAlbum: _newAlbum,
        isUpdate: false,
        isLoading: _isLoading,
        artwork: PlaylistArtwork(
          imageUrl: metaData?.imageUrl,
          isLoading: _isLoading,
        ),
        onDownloadedChanged: (v) => setState(() => _downloaded = v),
        onNewAlbumChanged: (v) => setState(() => _newAlbum = v),
        onSave: () async {
          if (validateTextFields()) {
            setState(() {
              _isLoading = true;
            });
            await _savePlaylist();
            SystemNavigator.pop();
          } else {
            setState(() {});
          }
        },
      ),
    );
  }
}
