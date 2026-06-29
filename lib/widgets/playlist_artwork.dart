import 'package:flutter/material.dart';

class PlaylistArtwork extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool isLoading;

  const PlaylistArtwork({
    super.key,
    required this.imageUrl,
    this.size = 160,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: isLoading
          ? SizedBox(
              width: size,
              height: size,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : imageUrl == null
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
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: loadingProgress == null
                          ? child
                          : SizedBox(
                              key: const ValueKey('image_spinner'),
                              width: size,
                              height: size,
                              child: Center(
                                child: SizedBox.shrink(),
                              ),
                            ),
                    );
                  },
                ),
    );
  }
}
