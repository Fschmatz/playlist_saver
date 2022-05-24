import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../db/tag_dao.dart';

class NewTag extends StatefulWidget {
  @override
  _NewTagState createState() => _NewTagState();

  const NewTag({Key? key}) : super(key: key);
}

class _NewTagState extends State<NewTag> {

  final tags = TagDao.instance;
  TextEditingController customControllerName = TextEditingController();
  bool _validName = true;

  void _saveTag() async {
    Map<String, dynamic> row = {
      TagDao.columnName: customControllerName.text,
    };
    final id = await tags.insert(row);
  }

  bool validateTextFields() {
    String errors = "";
    if (customControllerName.text.isEmpty) {
      errors += "Name";
      _validName = false;
    }
    return errors.isEmpty ? true : false;
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
                _saveTag();
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
                  errorText: _validName ? null : "Name is empty"
                ),
              ),
            ),
        ],
      ),
    );
  }
}
