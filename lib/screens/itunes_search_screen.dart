import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/itunes_media.dart';
import '../view_models/itunes_viewmodel.dart';
import 'ItunesDetailsScreen.dart';




class ItunesSearchScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ItunesViewModel>(
      create: (_) => ItunesViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('iTunes'),
          actions: [
            Consumer<ItunesViewModel>(
              builder: (context, model, child) {
                return IconButton(
                  icon: Icon(model.isGrid ? Icons.list : Icons.grid_view),
                  onPressed: () {
                    model.toggleView();
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<ItunesViewModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search iTunes...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          model.fetchMedia(_searchController.text);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    children: ['album', 'movie', 'musicVideo', 'song'].map((type) {
                      return FilterChip(
                        label: Text(type),
                        selected: model.selectedMediaTypes.contains(type),
                        onSelected: (bool selected) {
                          model.selectMediaType(type);
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  model.isLoading
                      ? CircularProgressIndicator()
                      : model.errorMessage.isNotEmpty
                      ? Text(model.errorMessage, style: TextStyle(color: Colors.red))
                      : model.mediaList.isEmpty
                      ? Text('No results found.')
                      : Expanded(
                    child: model.isGrid ? buildGridView(context, model) : buildListView(context, model),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGridView(BuildContext context, ItunesViewModel model) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: model.mediaList.length,
      itemBuilder: (context, index) {
        final media = model.mediaList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItunesDetailsScreen(media: media)),
            );
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(media.artworkUrl100, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(media.trackName, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(media.artistName),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildListView(BuildContext context, ItunesViewModel model) {
    return ListView.builder(
      itemCount: model.mediaList.length,
      itemBuilder: (context, index) {
        final media = model.mediaList[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItunesDetailsScreen(media: media)),
            );
          },
          leading: Image.network(media.artworkUrl100, fit: BoxFit.cover),
          title: Text(media.trackName),
          subtitle: Text(media.artistName),
        );
      },
    );
  }
}

