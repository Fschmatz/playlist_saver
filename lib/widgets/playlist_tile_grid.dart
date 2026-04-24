import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playlist_saver/service/playlist_service.dart';
import 'package:playlist_saver/util/utils_functions.dart';
import 'package:share_plus/share_plus.dart';

import '../class/playlist.dart';
import '../enum/destination.dart';
import '../pages/edit_playlist.dart';
import '../redux/selectors.dart';

class PlaylistTileGrid extends StatefulWidget {
  @override
  State<PlaylistTileGrid> createState() => _PlaylistTileGridState();

  final Playlist playlist;
  final int index;
  final bool showAlbumInfo;

  const PlaylistTileGrid({super.key, required this.playlist, required this.index, required this.showAlbumInfo});
}

class _PlaylistTileGridState extends State<PlaylistTileGrid> {
  final PlaylistService playlistService = PlaylistService();
  final BorderRadius _cardBorderRadius = BorderRadius.circular(12);
  final double _tagHeight = 25;
  final double _tagWidth = 25;
  final double _tagIconSize = 19;

  void _launchLink() {
    UtilsFunctions.launchBrowser(widget.playlist.link);
  }

  Future<void> _delete() async {
    await playlistService.delete(widget.playlist);
  }

  Future<void> _changePlaylistState(int state) async {
    await playlistService.changePlaylistState(widget.playlist, state);
  }

  bool isCurrentPageDownloads() {
    return selectCurrentDestination() == Destination.downloads;
  }

  void openBottomMenu() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    minVerticalPadding: 0,
                    title: Text(
                      widget.playlist.title,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: widget.playlist.artist!.isNotEmpty
                        ? Text(
                            widget.playlist.artist!,
                            textAlign: TextAlign.center,
                          )
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: SegmentedButton<int>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(value: 0, label: Text('Listen'), icon: Icon(Icons.queue_music_outlined)),
                          ButtonSegment(value: 1, label: Text('Archive'), icon: Icon(Icons.archive_outlined)),
                          ButtonSegment(value: 2, label: Text('Favorite'), icon: Icon(Icons.favorite_border_outlined)),
                        ],
                        selected: {widget.playlist.state},
                        onSelectionChanged: (s) => {_changePlaylistState(s.first), Navigator.of(context).pop()},
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: const Text(
                      "Share",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Share.share("${widget.playlist.title} - ${widget.playlist.artist!}\n\n${widget.playlist.link}");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text(
                      "Edit",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditPlaylist(
                              playlist: widget.playlist,
                            ),
                          ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_outlined),
                    title: const Text(
                      "Delete",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _delete();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Image? cover = (widget.playlist.cover != null)
        ? Image.memory(
            widget.playlist.cover!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          )
        : null;
    final colorScheme = Theme.of(context).colorScheme;
    final disabledColor = Theme.of(context).disabledColor;
    final alertBackgroundColor = colorScheme.primaryContainer;
    final alertIconColor = colorScheme.onPrimaryContainer;

    bool showAlbumInfo = widget.showAlbumInfo;
    BorderRadius coverBorder =
        showAlbumInfo ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)) : BorderRadius.circular(12);

    return Card(
      margin: const EdgeInsets.all(3),
      shape: showAlbumInfo
          ? null
          : RoundedRectangleBorder(
              side: BorderSide(color: colorScheme.surfaceContainerHighest, width: 2),
              borderRadius: _cardBorderRadius,
            ),
      color: colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: _cardBorderRadius,
        onTap: _launchLink,
        onLongPress: openBottomMenu,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  (cover == null)
                      ? SizedBox.expand(
                          child: Icon(
                            Icons.music_note_outlined,
                            size: 30,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      : Positioned.fill(
                          child: ClipRRect(
                            borderRadius: coverBorder,
                            child: Opacity(
                              opacity: 0.9,
                              child: cover,
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: showAlbumInfo ? 3 : 5,
                    right: showAlbumInfo ? 3 : 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: widget.playlist.isNewAlbum(),
                          child: Container(
                            width: _tagHeight,
                            height: _tagWidth,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: alertBackgroundColor,
                            ),
                            child: Icon(
                              Icons.new_releases_outlined,
                              size: _tagIconSize,
                              color: alertIconColor,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.playlist.isDownloaded(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                            child: Container(
                              width: _tagHeight,
                              height: _tagWidth,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: alertBackgroundColor,
                              ),
                              child: Icon(
                                Icons.download_outlined,
                                size: _tagIconSize,
                                color: alertIconColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showAlbumInfo) ...[
              const SizedBox(
                height: 3,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    widget.playlist.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    widget.playlist.artist!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: disabledColor),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
