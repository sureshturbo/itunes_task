import 'package:flutter/material.dart';
import '../models/itunes_media.dart';

class ItunesDetailsScreen extends StatelessWidget {
  final ItunesMedia media;

  const ItunesDetailsScreen({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  media.artworkUrl100,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(media.trackName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(media.artistName),
                      Text(
                        media.primaryGenreName,
                        style: TextStyle(color: Colors.yellow[700], fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                        },
                        child: Text('Preview'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Preview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Image.network(
              media.previewUrl,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(media.description ?? 'No description available.'),
          ],
        ),
      ),
    );
  }
}
