import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlaylistForm extends StatelessWidget {
  final TextEditingController linkController;
  final TextEditingController titleController;
  final TextEditingController artistController;
  final bool showLinkField;
  final bool validLink;
  final bool validTitle;
  final bool downloaded;
  final bool newAlbum;
  final void Function(bool) onDownloadedChanged;
  final void Function(bool) onNewAlbumChanged;
  final VoidCallback onSave;
  final VoidCallback? onLinkSubmitted;
  final String appBarTitle;
  final Widget? artwork;
  final bool isUpdate;

  const PlaylistForm({
    super.key,
    required this.linkController,
    required this.titleController,
    required this.artistController,
    required this.validLink,
    required this.validTitle,
    required this.downloaded,
    required this.newAlbum,
    required this.onDownloadedChanged,
    required this.onNewAlbumChanged,
    required this.onSave,
    required this.appBarTitle,
    required this.isUpdate,
    this.onLinkSubmitted,
    this.showLinkField = true,
    this.artwork,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: ListView(
        children: [
          if (artwork != null)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [artwork!],
              ),
            ),
          if (showLinkField)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                autofocus: !isUpdate,
                minLines: 1,
                maxLines: 4,
                maxLength: 500,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.name,
                controller: linkController,
                onSubmitted: (_) => onLinkSubmitted?.call(),
                decoration: InputDecoration(
                  labelText: "Link",
                  helperText: "* Required",
                  counterText: "",
                  border: const OutlineInputBorder(),
                  errorText: validLink ? null : "Link is empty",
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              minLines: 1,
              maxLines: 3,
              maxLength: 300,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                helperText: "* Required",
                counterText: "",
                border: const OutlineInputBorder(),
                errorText: validTitle ? null : "Title is empty",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 300,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.name,
              controller: artistController,
              decoration: const InputDecoration(
                labelText: "Artist",
                counterText: "",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text("Downloaded"),
            subtitle: const Text("Downloaded to device"),
            value: downloaded,
            onChanged: onDownloadedChanged,
          ),
          SwitchListTile(
            title: const Text("New album"),
            subtitle: const Text("Highlight as new"),
            value: newAlbum,
            onChanged: onNewAlbumChanged,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: FilledButton.tonalIcon(
              onPressed: onSave,
              icon: const Icon(Icons.save_outlined),
              label: const Text("Save"),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
