import 'package:flutter/material.dart';
import '../../class/tag.dart';
import '../../db/tag_dao.dart';
import '../../db/playlists_tags_dao.dart';
import '../../service/tag_service.dart';
import 'edit_tag.dart';
import 'new_tag.dart';

class TagsManager extends StatefulWidget {
  const TagsManager({Key? key}) : super(key: key);

  @override
  _TagsManagerState createState() => _TagsManagerState();
}

class _TagsManagerState extends State<TagsManager> {
  bool loadingTags = true;
  final tags = TagDao.instance;
  final playlistsTags = PlaylistsTagsDao.instance;
  List<Tag> _tagsList = [];

  @override
  void initState() {
    super.initState();
    getTags();
  }

  Future<void> _delete(int idTag) async {
    await tags.delete(idTag);
    await playlistsTags.deleteWithTagId(idTag);
  }

  Future<void> getTags() async {
    _tagsList = await TagService().queryAllRowsByName();

    setState(() {
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
        title: const Text("Tags"),
      ),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => const Divider(
              height: 5,
            ),
            shrinkWrap: true,
            itemCount: _tagsList.length,
            itemBuilder: (BuildContext context, int index) {
              Tag tag = _tagsList[index];

              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                title: Text(tag.name),
                trailing: Visibility(
                  visible: tag.idTag != 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            size: 20,
                          ),
                          onPressed: () {
                            showAlertDialogOkDelete(context, tag.idTag);
                          }),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => EditTag(
                                    tag: tag,
                                  ),
                                )).then((value) => getTags());
                          }),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const NewTag(),
              )).then((value) => getTags());
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
