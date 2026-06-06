import 'dart:convert';

import 'package:home_widget/home_widget.dart';

import '../class/playlist.dart';

class WidgetService {
  static const String androidWidgetName = 'PlaylistWidgetProvider';

  static Future<void> updatePlaylistWidget(List<Playlist> playlists) async {
    try {
      final List<Map<String, String>> data = playlists.map((p) {
        return {
          'id': p.idPlaylist.toString(),
          'title': p.title,
          'artist': p.artist ?? '',
          'link': p.link,
          'downloaded': p.downloaded == 1 ? 'true' : 'false',
          'cover': p.cover != null ? base64Encode(p.cover!) : '',
        };
      }).toList();

      final jsonString = jsonEncode(data);

      await HomeWidget.saveWidgetData<String>('playlists_json', jsonString);

      await HomeWidget.updateWidget(
        name: androidWidgetName,
      );
    } catch (e) {
      // Ignore errors
    }
  }
}
