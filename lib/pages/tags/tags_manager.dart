import 'package:flutter/material.dart';
import '../../class/tag.dart';
import '../../db/tag_dao.dart';
import '../../db/playlists_tags_dao.dart';
import 'edit_tag.dart';
import 'new_tag.dart';

class TagsManager extends StatefulWidget {
  TagsManager({Key? key}) : super(key: key);

  @override
  _TagsManagerState createState() => _TagsManagerState();
}

class _TagsManagerState extends State<TagsManager> {
  bool loadingTags = true;
  final tags = TagDao.instance;
  final tasksTags = PlaylistsTagsDao.instance;
  List<Map<String, dynamic>> _tagsList = [];

  @override
  void initState() {
    super.initState();
    getTags();
  }

  Future<void> _delete(int idTag) async {
    final deleted = await tags.delete(idTag);
    final deletedTaskTag = await tasksTags.deleteWithTagId(idTag);
  }

  Future<void> getTags() async {
    var resp = await tags.queryAllRowsByName();
    setState(() {
      _tagsList = resp;
      loadingTags = false;
    });
  }

  showAlertDialogOkDelete(BuildContext context, idTag) {
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
                _delete(idTag).then((value) => getTags());
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Tags"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_outlined,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const NewTag(),
                  )).then((value) => getTags());
            },
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder:
            (BuildContext context, int index) =>
        const SizedBox(
          height: 5,
        ),
        shrinkWrap: true,
        itemCount: _tagsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            child: ListTile(
              title: Text(_tagsList[index]['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _tagsList.length > 1
                      ? IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            size: 22,
                          ),
                          onPressed: () {
                            showAlertDialogOkDelete(
                                context, _tagsList[index]['id_tag']);
                          })
                      : const SizedBox.shrink(),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditTag(
                                tag: Tag(
                                  _tagsList[index]['id_tag'],
                                  _tagsList[index]['name'],
                                ),
                              ),
                            )).then((value) => getTags());
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}