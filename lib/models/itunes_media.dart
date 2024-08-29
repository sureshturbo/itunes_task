

class ItunesMedia {
  final String trackName;
  final String artistName;
  final String artworkUrl100;
  final String primaryGenreName;
  final String previewUrl;
  final String? description;
  final String type; // Add this line

  ItunesMedia({
    required this.trackName,
    required this.artistName,
    required this.artworkUrl100,
    required this.primaryGenreName,
    required this.previewUrl,
    this.description,
    required this.type,
  });

  factory ItunesMedia.fromJson(Map<String, dynamic> json) {
    return ItunesMedia(
        trackName: json['trackName'] ?? 'Unknown Track',
        artistName: json['artistName'] ?? 'Unknown Artist',
        artworkUrl100: json['artworkUrl100'] ?? '',
        primaryGenreName: json['primaryGenreName'] ?? 'Unknown Genre',
        previewUrl: json['previewUrl'] ?? '',
        description: json['longDescription'],
        type: json['kind'] ?? '', // Update this line
    );
  }}