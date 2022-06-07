import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../class/tag.dart';
import '../../db/tag_dao.dart';

class EditTag extends StatefulWidget {

  @override
  _EditTagState createState() => _EditTagState();

  Tag tag;
  EditTag({Key? key,required this.tag}) : super(key: key);
}

class _EditTagState extends State<EditTag> {

  final tags = TagDao.instance;
  TextEditingController customControllerName = TextEditingController();
  bool _validName = true;

  @override
  void initState() {
    super.initState();
    customControllerName.text = widget.tag.name;
  }

  void _updateTag() async {
    Map<String, dynamic> row = {
      TagDao.columnId: widget.tag.idTag,
      TagDao.columnName: customControllerName.text,
    };
    final update = await tags.update(row);
  }

  bool validateTextFields() {
    if (customControllerName.text.isEmpty) {
      _validName = false;
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Save',
            icon: const Icon(
              Icons.save_outlined,
            ),
            onPressed: () async {
              if (validateTextFields()) {
                _updateTag();
                Navigator.of(context).pop();
              } else {
                setState(() {
                  _validName;
                });
              }
            },
          )
        ],
        title: const Text('New Tag'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              minLines: 1,
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerName,
              textCapitalization: TextCapitalization.sentences,
              decoration:  InputDecoration(
                  counterText: "",
                  helperText: "* Required",
                  labelText: "Name",
                  errorText: (_validName) ? null : "Name is empty"
              ),
            ),
          ),
        ],
      ),
    );
  }
}
