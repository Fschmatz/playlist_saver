import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:home_widget/home_widget.dart';

import '../class/playlist.dart';

class WidgetService {
  static const String androidWidgetName = 'PlaylistWidgetProvider';

  static Future<void> updatePlaylistWidget(List<Playlist> playlists) async {
    try {
      final List<Map<String, String>> data = [];

      // Limit 50
      final updateList = playlists.take(50).toList();

      for (var p in updateList) {
        String base64Cover = '';

        if (p.cover != null) {
          try {
            // Compress image
            final Uint8List compressedCover = await FlutterImageCompress.compressWithList(
              p.cover!,
              minHeight: 100,
              minWidth: 100,
              quality: 70,
              format: CompressFormat.jpeg,
            );

            base64Cover = base64Encode(compressedCover);
          } catch (e) {
            base64Cover = base64Encode(p.cover!);
          }
        }

        data.add({
          'id': p.idPlaylist.toString(),
          'title': p.title,
          'artist': p.artist ?? '',
          'link': p.link,
          'downloaded': p.downloaded == 1 ? 'true' : 'false',
          'cover': base64Cover,
        });
      }

      final jsonString = jsonEncode(data);

      await HomeWidget.saveWidgetData<String>('playlists_json', jsonString);

      await HomeWidget.updateWidget(
        name: androidWidgetName,
      );
    } catch (e) {
      // Ignore
    }
  }
}
