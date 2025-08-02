import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:web_scraper/web_scraper.dart';

import '../class/spotify_metadata.dart';

class SpotifyMetadataService {
  Future<SpotifyMetadata?> loadMetadata(String link) async {
    final webScraper = WebScraper();

    if (await webScraper.loadFullURL(link)) {
      final ogTitle = webScraper.getElement('meta[property="og:title"]', ['content']).first['attributes']['content'] as String?;

      final ogDescription = webScraper.getElement('meta[property="og:description"]', ['content']).first['attributes']['content'] as String?;

      final ogImage = webScraper.getElement('meta[property="og:image"]', ['content']).first['attributes']['content'] as String?;

      List<Map<String, dynamic>> elements = webScraper.getElement('head > title', ['content']);
      String artistDataElement = elements[0]['title'];

      if (ogTitle != null && ogDescription != null && ogImage != null) {
        return SpotifyMetadata(title: ogTitle, description: ogDescription, imageUrl: ogImage, artistName: formatArtistNameToSave(artistDataElement));
      }
    }

    return null;
  }

  Future<Uint8List> compressCoverImage(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 250,
      minWidth: 250,
      quality: 70,
    );
    return result;
  }

  String formatArtistNameToSave(String artistFromHTML) {
    String formattedArtistName = "";

    if (artistFromHTML.contains('This Is ')) {
      formattedArtistName =
          artistFromHTML.replaceAll('This Is ', '').replaceAll(' - playlist by Spotify | Spotify', '').replaceAll(' | Spotify Playlist', '');
    }
    if (artistFromHTML.contains('song and lyrics by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1].replaceAll(' | Spotify', '');
    }
    if (artistFromHTML.contains('Album by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1].replaceAll(' | Spotify', '');
    }
    if (artistFromHTML.contains('Single by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1].replaceAll(' | Spotify', '');
    }
    if (artistFromHTML.contains('Ep by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1].replaceAll(' | Spotify', '');
    }

    return formattedArtistName.trim();
  }

  String formatTitleToSave(String title) {
    if (title.isNotEmpty) {
      List<int> bytes = latin1.encode(title);

      return utf8.decode(bytes);
    } else {
      return "";
    }
  }
}
