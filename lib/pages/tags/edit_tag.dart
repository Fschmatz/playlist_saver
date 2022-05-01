import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../class/tag.dart';
import '../../db/tag_dao.dart';
import '../../widgets/dialog_alert_error.dart';

class EditTag extends StatefulWidget {

  @override
  _EditTagState createState() => _EditTagState();

  Tag tag;
  EditTag({Key? key,required this.tag}) : super(key: key);
}

class _EditTagState extends State<EditTag> {

  final tags = TagDao.instance;
  TextEditingController customControllerName = TextEditingController();
  Color pickerColor = const Color(0xFFe35b5b);
  Color currentColor = const Color(0xFFe35b5b);

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
                _updateTag();
                Navigator.of(context).pop();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return  dialogAlertErrors(errors,context);
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
