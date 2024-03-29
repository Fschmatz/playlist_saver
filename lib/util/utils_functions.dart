import 'dart:typed_data';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter_image_compress/flutter_image_compress.dart';

String capitalizeFirstLetterString(String word){
  return word.replaceFirst(word[0], word[0].toUpperCase());
}

Color parseColorFromDb(String color){
  return Color(int.parse(color.substring(6, 16)));
}

Color getRandomColor(){
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

Color darkenColor(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(
      c.alpha,
      (c.red * f).round(),
      (c.green  * f).round(),
      (c.blue * f).round()
  );
}

Color lightenColor(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round()
  );
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