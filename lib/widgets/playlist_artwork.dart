import 'package:flutter/material.dart';

class PlaylistArtwork extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final BorderRadius borderRadius;

  const PlaylistArtwork({
    super.key,
    required this.imageUrl,
    this.size = 125,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null
          ? SizedBox(
              width: size,
              height: size,
              child: const Center(
                child: Icon(
                  Icons.music_note_outlined,
                  size: 30,
                ),
              ),
            )
          : Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
    );
  }
}
