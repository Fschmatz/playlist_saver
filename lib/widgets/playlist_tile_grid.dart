import 'dart:async';
import 'package:flutter/material.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:share_plus/share_plus.dart';
import '../class/playlist.dart';
import '../pages/edit_playlist.dart';
import '../util/utils.dart';

class PlaylistTileGrid extends StatefulWidget {
  @override
  State<PlaylistTileGrid> createState() => _PlaylistTileGridState();

  final Playlist playlist;
  final Function() refreshHome;
  final int index;
  final Function(int) removeFromList;
  final bool isPageDownloads;

  const PlaylistTileGrid(
      {super.key, required this.playlist, required this.refreshHome, required this.index, required this.isPageDownloads, required this.removeFromList});
}

class _PlaylistTileGridState extends State<PlaylistTileGrid> {
  bool deleteAfterTimer = true;
  double coverHeight = 120;
  double coverWidth = 200;
  BorderRadius cardBorderRadius = BorderRadius.circular(12);
  bool isNewAlbum = false;

  @override
  void initState() {
    super.initState();
  }

  _launchLink() {
    Utils().launchBrowser(widget.playlist.link);
  }

  void _delete() async {
    final playlists = PlaylistDao.instance;

    await playlists.delete(widget.playlist.idPlaylist);
  }

  Future<void> _changePlaylistState(int state) async {
    final dbPlaylist = PlaylistDao.instance;
    Map<String, dynamic> row = {
      PlaylistDao.columnIdPlaylist: widget.playlist.idPlaylist,
      PlaylistDao.columnState: state,
    };

    await dbPlaylist.update(row);
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
                    visible: widget.playlist.state != 0 && !widget.isPageDownloads,
                    child: ListTile(
                      leading: const Icon(Icons.queue_music_outlined),
                      title: const Text(
                        "Listen",
                      ),
                      onTap: () {
                        _changePlaylistState(0);
                        widget.refreshHome();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.playlist.state != 1 && !widget.isPageDownloads,
                    child: ListTile(
                      leading: const Icon(Icons.archive_outlined),
                      title: const Text(
                        "Archive",
                      ),
                      onTap: () {
                        _changePlaylistState(1);
                        widget.refreshHome();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.playlist.state != 2 && !widget.isPageDownloads,
                    child: ListTile(
                      leading: const Icon(Icons.favorite_border_outlined),
                      title: const Text(
                        "Favorite",
                      ),
                      onTap: () {
                        _changePlaylistState(2);
                        widget.refreshHome();
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
                              refreshHome: widget.refreshHome,
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
                      widget.removeFromList(widget.index);
                      Navigator.of(context).pop();
                      _showSnackBar();
                      Timer(const Duration(seconds: 5), () {
                        if (deleteAfterTimer) {
                          _delete();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Playlist deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            deleteAfterTimer = false;
            widget.refreshHome();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    Image? cover = (widget.playlist.cover != null)
        ? Image.memory(
            widget.playlist.cover!,
            height: coverHeight,
            width: coverWidth,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          )
        : null;

    return Card(
      child: InkWell(
        borderRadius: cardBorderRadius,
        onTap: _launchLink,
        onLongPress: openBottomMenu,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                (cover == null)
                    ? SizedBox(
                        height: coverHeight,
                        width: coverWidth,
                        child: Icon(
                          Icons.music_note_outlined,
                          size: 30,
                          color: theme.hintColor,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: cardBorderRadius,
                        child: Opacity(
                          opacity: 0.9,
                          child: cover,
                        ),
                      ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Row(
                    children: [
                      Visibility(
                        visible: widget.playlist.isNewAlbum(),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: Icon(
                            Icons.new_releases_outlined,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Visibility(
                        visible: widget.playlist.isDownloaded(),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          child: Icon(
                            Icons.download_outlined,
                            size: 18,
                            color: theme.colorScheme.primary,
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: theme.hintColor),
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
                  style: TextStyle(fontSize: 10, color: theme.hintColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
