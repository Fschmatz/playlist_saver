import 'dart:async';

import 'package:flutter/material.dart';
import 'package:playlist_saver/service/playlist_service.dart';
import 'package:share_plus/share_plus.dart';

import '../class/playlist.dart';
import '../enum/destination.dart';
import '../pages/edit_playlist.dart';
import '../redux/selectors.dart';
import '../util/utils.dart';

class PlaylistTileGrid extends StatefulWidget {
  @override
  State<PlaylistTileGrid> createState() => _PlaylistTileGridState();

  final Playlist playlist;
  final int index;

  const PlaylistTileGrid({super.key, required this.playlist, required this.index});
}

class _PlaylistTileGridState extends State<PlaylistTileGrid> {
  final PlaylistService playlistService = PlaylistService();
  final double _coverHeight = 120;
  final double _coverWidth = 200;
  final BorderRadius _cardBorderRadius = BorderRadius.circular(12);
  final bool _isNewAlbum = false;

  @override
  void initState() {
    super.initState();
  }

  void _launchLink() {
    Utils().launchBrowser(widget.playlist.link);
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
                  const Divider(),
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
                  Visibility(
                    visible: widget.playlist.state != 0 && !isCurrentPageDownloads(),
                    child: ListTile(
                      leading: const Icon(Icons.queue_music_outlined),
                      title: const Text(
                        "Listen",
                      ),
                      onTap: () {
                        _changePlaylistState(0);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.playlist.state != 1 && !isCurrentPageDownloads(),
                    child: ListTile(
                      leading: const Icon(Icons.archive_outlined),
                      title: const Text(
                        "Archive",
                      ),
                      onTap: () {
                        _changePlaylistState(1);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.playlist.state != 2 && !isCurrentPageDownloads(),
                    child: ListTile(
                      leading: const Icon(Icons.favorite_border_outlined),
                      title: const Text(
                        "Favorite",
                      ),
                      onTap: () {
                        _changePlaylistState(2);
                        Navigator.of(context).pop();
                      },
                    ),
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
    final colorScheme = Theme.of(context).colorScheme;
    Image? cover = (widget.playlist.cover != null)
        ? Image.memory(
            widget.playlist.cover!,
            height: _coverHeight,
            width: _coverWidth,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          )
        : null;

    return Card(
      color: colorScheme.surfaceContainerHigh,
      child: InkWell(
        borderRadius: _cardBorderRadius,
        onTap: _launchLink,
        onLongPress: openBottomMenu,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                (cover == null)
                    ? SizedBox(
                        height: _coverHeight,
                        width: _coverWidth,
                        child: Icon(
                          Icons.music_note_outlined,
                          size: 30,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: _cardBorderRadius,
                        child: Opacity(
                          opacity: 0.9,
                          child: cover,
                        ),
                      ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: widget.playlist.isNewAlbum(),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            Icons.new_releases_outlined,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.playlist.isDownloaded(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primaryContainer,
                            ),
                            child: Icon(
                              Icons.download_outlined,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: colorScheme.onPrimaryContainer),
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
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: colorScheme.onSecondaryContainer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
