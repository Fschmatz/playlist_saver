import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_saver/db/playlist_dao.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../class/playlist.dart';
import '../db/tag_dao.dart';
import '../pages/edit_playlist.dart';

class PlaylistTile extends StatefulWidget {
  @override
  _PlaylistTileState createState() => _PlaylistTileState();

  Playlist playlist;
  Function() refreshHome;

  PlaylistTile({Key? key, required this.playlist, required this.refreshHome})
      : super(key: key);
}

class _PlaylistTileState extends State<PlaylistTile> {
  List<Map<String, dynamic>> tagsList = [];
  final tags = TagDao.instance;
  bool loadingTags = true;

  @override
  void initState() {
    super.initState();
    getTags();
  }

  void getTags() async {
    var resp = await tags.getTagsByIdTaskOrderName(widget.playlist.idPlaylist);
    if (mounted) {
      setState(() {
        tagsList = resp;
        loadingTags = false;
      });
    }
  }

  _launchLink() {
    launchUrl(
      Uri.parse(widget.playlist.link),
      mode: LaunchMode.externalApplication,
    );
  }

  void _delete() async {
    final playlists = PlaylistDao.instance;
    final deleted = await playlists.delete(widget.playlist.idPlaylist);
  }

  Future<void> _archivePlaylist() async {
    final dbPlaylist = PlaylistDao.instance;
    Map<String, dynamic> row = {
      PlaylistDao.columnIdPlaylist: widget.playlist.idPlaylist,
      PlaylistDao.columnArchived: widget.playlist.archived == 0 ? 1 : 0,
    };
    final update = await dbPlaylist.update(row);
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
                    leading: widget.playlist.archived == 0
                        ? const Icon(Icons.archive_outlined)
                        : const Icon(Icons.unarchive_outlined),
                    title: widget.playlist.archived == 0
                        ? const Text(
                            "Archive playlist",
                          )
                        : const Text(
                            "Unarchive playlist",
                          ),
                    onTap: () {
                      _archivePlaylist();
                      widget.refreshHome();
                      Navigator.of(context).pop();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: const Text(
                      "Share playlist",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Share.share(widget.playlist.link);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text(
                      "Edit playlist",
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
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_outline_outlined),
                    title: const Text(
                      "Delete playlist",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      showAlertDialogOkDelete(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialogOkDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm",
          ),
          content: const Text(
            "Delete ?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () {
                _delete();
                widget.refreshHome();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchLink,
      onLongPress: openBottomMenu,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: widget.playlist.cover == null
                        ? SizedBox(
                            height: 90,
                            width: 90,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.music_note_outlined,
                                size: 30,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 90,
                            width: 90,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.memory(
                                  widget.playlist.cover!,
                                  fit: BoxFit.cover,
                                  //filterQuality: FilterQuality.medium,
                                  gaplessPlayback: true,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Expanded(
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
                      const SizedBox(
                        height: 7,
                      ),
                      Visibility(
                        visible: widget.playlist.artist!.isNotEmpty,
                        child: Text(
                          widget.playlist.artist!,
                          style: TextStyle(
                              fontSize: 16, color: Theme.of(context).hintColor),
                        ),
                      ),
                      tagsList.isEmpty
                          ? const SizedBox.shrink()
                          : Wrap(
                              runSpacing: 5,
                              children: List<Widget>.generate(tagsList.length,
                                  (int index) {
                                return index == 0
                                    ? Text(
                                        tagsList[index]['name'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )
                                    : Text(
                                        " • " + tagsList[index]['name'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      );
                              }).toList(),
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
