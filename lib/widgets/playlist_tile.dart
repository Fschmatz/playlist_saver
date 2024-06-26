import 'dart:async';
import 'package:flutter/material.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../class/playlist.dart';
import '../db/playlists_tags_dao.dart';
import '../db/tag_dao.dart';
import '../pages/edit_playlist.dart';
import '../util/utils.dart';

class PlaylistTile extends StatefulWidget {
  @override
  _PlaylistTileState createState() => _PlaylistTileState();

  Playlist playlist;
  Function() refreshHome;
  int index;
  Function(int) removeFromList;
  bool isPageDownloads;

  PlaylistTile(
      {Key? key, required this.playlist, required this.refreshHome, required this.index, required this.isPageDownloads, required this.removeFromList})
      : super(key: key);
}

class _PlaylistTileState extends State<PlaylistTile> {
  List<Map<String, dynamic>> tagsList = [];
  final tags = TagDao.instance;
  bool loadingTags = true;
  bool deleteAfterTimer = true;

  @override
  void initState() {
    super.initState();

    loadTags();
  }

  void loadTags() async {
    var resp = await tags.getTagsByIdTaskOrderName(widget.playlist.idPlaylist);
    if (mounted) {
      setState(() {
        tagsList = resp;
        loadingTags = false;
      });
    }
  }

  _launchLink() {
    Utils().launchBrowser(widget.playlist.link);
  }

  void _delete() async {
    final playlists = PlaylistDao.instance;
    final tasksTags = PlaylistsTagsDao.instance;

    await playlists.delete(widget.playlist.idPlaylist);
    await tasksTags.deleteWithIdPlaylist(widget.playlist.idPlaylist);
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
            fit: BoxFit.cover,
            gaplessPlayback: true,
          )
        : null;

    return InkWell(
      onTap: _launchLink,
      onLongPress: openBottomMenu,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: (cover == null)
                        ? SizedBox(
                            height: 85,
                            width: 85,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.music_note_outlined,
                                size: 30,
                                color: theme.hintColor,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 85,
                            width: 85,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ClipRRect(borderRadius: BorderRadius.circular(6), child: cover),
                            ),
                          ),
                  ),
                ),
                (loadingTags)
                    ? const SizedBox.shrink()
                    : Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.playlist.title,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Visibility(
                              visible: widget.playlist.artist!.isNotEmpty,
                              child: Text(
                                widget.playlist.artist!,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: theme.hintColor),
                              ),
                            ),
                            Visibility(
                              visible: widget.playlist.artist!.isNotEmpty,
                              child: const SizedBox(
                                height: 0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (tagsList.isEmpty)
                                    ? const SizedBox.shrink()
                                    : Expanded(
                                        child: Wrap(
                                          children: List<Widget>.generate(tagsList.length, (int index) {
                                            return index == 0
                                                ? Text(
                                                    tagsList[index]['name'],
                                                    style: TextStyle(
                                                        fontSize: 12, fontWeight: FontWeight.w500, color: theme.colorScheme.primary),
                                                  )
                                                : Text(
                                                    " • ${tagsList[index]['name']}",
                                                    style: TextStyle(
                                                        fontSize: 12, fontWeight: FontWeight.w500, color: theme.colorScheme.primary),
                                                  );
                                          }).toList(),
                                        ),
                                      ),
                                Visibility(
                                    visible: widget.playlist.isDownloaded(),
                                    child: Icon(
                                      Icons.download_outlined,
                                      size: 16,
                                      color: theme.colorScheme.primary,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
