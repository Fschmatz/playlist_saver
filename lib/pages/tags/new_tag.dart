import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../db/tag_dao.dart';
import '../../widgets/dialog_alert_error.dart';

class NewTag extends StatefulWidget {
  @override
  _NewTagState createState() => _NewTagState();

  const NewTag({Key? key}) : super(key: key);
}

class _NewTagState extends State<NewTag> {
  final tags = TagDao.instance;
  TextEditingController customControllerName = TextEditingController();

  void _saveTag() async {
    Map<String, dynamic> row = {
      TagDao.columnName: customControllerName.text,
    };
    final id = await tags.insert(row);
  }

  String checkForErrors() {
    String errors = "";
    if (customControllerName.text.isEmpty) {
      errors += "Name is empty\n";
    }
    return errors;
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
              String errors = checkForErrors();
              if (errors.isEmpty) {
                _saveTag();
                Navigator.of(context).pop();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return dialogAlertErrors(errors, context);
                  },
                );
              }
            },
          )
        ],
        title: const Text('New Tag'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Name",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          ListTile(
            title: TextField(
              autofocus: true,
              minLines: 1,
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: customControllerName,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: "",
                helperText: "* Required",
                prefixIcon: Icon(
                  Icons.notes_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
