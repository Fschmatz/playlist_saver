import 'package:flutter/material.dart';
import 'package:playlist_saver/enum/playlist_status.dart';

import 'custom_text_field.dart';

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
  final void Function(PlaylistStatus)? onPlaylistStateChanged;
  final PlaylistStatus? playlistState;

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
    this.isUpdate = false,
    this.onLinkSubmitted,
    this.showLinkField = true,
    this.artwork,
    this.onPlaylistStateChanged,
    this.playlistState,
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
            CustomTextField(
              label: "Link",
              controller: linkController,
              required: true,
              maxLines: 4,
              maxLength: 500,
              fieldValidator: validLink,
              errorMsg: "Link is empty",
              autofocus: !isUpdate,
              onSubmitted: (_) => onLinkSubmitted?.call(),
            ),
          CustomTextField(
            label: "Title",
            controller: titleController,
            required: true,
            maxLines: 3,
            maxLength: 300,
            fieldValidator: validTitle,
            errorMsg: "Title is empty",
          ),
          CustomTextField(
            label: "Artist",
            controller: artistController,
            required: false,
            maxLines: 2,
            maxLength: 300,
            fieldValidator: true,
            errorMsg: "",
          ),
          if (isUpdate) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: DropdownMenu<PlaylistStatus>(
                initialSelection: playlistState,
                expandedInsets: EdgeInsets.zero,
                label: const Text('Status'),
                onSelected: (PlaylistStatus? value) {
                  if (value != null) {
                    onPlaylistStateChanged?.call(value);
                  }
                },
                dropdownMenuEntries: PlaylistStatus.values.map((status) {
                  return DropdownMenuEntry<PlaylistStatus>(
                    value: status,
                    label: status.name,
                    leadingIcon: Icon(status.icon),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Downloaded"),
                    subtitle: const Text("Downloaded to device"),
                    value: downloaded,
                    onChanged: onDownloadedChanged,
                    secondary: const Icon(Icons.download_outlined),
                  ),
                  Divider(),
                  SwitchListTile(
                    title: const Text("New album"),
                    subtitle: const Text("Highlight as new"),
                    value: newAlbum,
                    onChanged: onNewAlbumChanged,
                    secondary: const Icon(Icons.new_releases_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onSave,
        icon: const Icon(Icons.save_outlined),
        label: const Text(
          "Save",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
