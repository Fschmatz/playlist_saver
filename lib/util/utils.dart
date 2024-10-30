import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_details.dart';

class Utils {

  openGithubRepository() {
    launchBrowser(AppDetails.repositoryLink);
  }

  launchBrowser(String url) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  String getThemeStringFormatted(ThemeMode? currentTheme) {
    String theme = currentTheme.toString().replaceAll('ThemeMode.', '');
    if (theme == 'system') {
      theme = 'system default';
    }
    return theme.replaceFirst(theme[0], theme[0].toUpperCase());
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

  String formatArtistNameToSave(String artistFromHTML){
    String formattedArtistName = "";

    if (artistFromHTML.contains('This Is ')) {
      formattedArtistName =
          artistFromHTML.replaceAll('This Is ', '').replaceAll(' - playlist by Spotify | Spotify', '');
    }
    if (artistFromHTML.contains('song and lyrics by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1]
          .replaceAll(' | Spotify', '');
    }
    if (artistFromHTML.contains('Album by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1]
          .replaceAll(' | Spotify', '');
    }
    if (artistFromHTML.contains('Single by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1]
          .replaceAll(' | Spotify', '');
    }
    if (artistFromHTML.contains('Ep by ')) {
      List<String> listSplit = artistFromHTML.split('by ');
      formattedArtistName = listSplit[1]
          .replaceAll(' | Spotify', '');
    }
    return formattedArtistName;
  }

}