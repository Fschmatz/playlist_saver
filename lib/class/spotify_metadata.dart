class SpotifyMetadata {
  final String title;
  final String description;
  final String imageUrl;
  final String? artistName;

  SpotifyMetadata({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.artistName,
  });

}
