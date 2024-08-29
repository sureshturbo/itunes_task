// lib/viewmodels/itunes_viewmodel.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/itunes_media.dart';


class ItunesViewModel with ChangeNotifier {
  List<ItunesMedia> _mediaList = [];
  List<ItunesMedia> _filteredMediaList = [];
  String _errorMessage = '';
  bool _isLoading = false;
  List<String> _selectedMediaTypes = [];
  bool _isGrid = true;

  List<ItunesMedia> get mediaList => _filteredMediaList;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  List<String> get selectedMediaTypes => _selectedMediaTypes;
  bool get isGrid => _isGrid;

  ItunesViewModel() {
    fetchMedia('all');
  }

  void toggleView() {
    _isGrid = !_isGrid;
    notifyListeners();
  }

  void selectMediaType(String mediaType) {
    if (_selectedMediaTypes.contains(mediaType)) {
      _selectedMediaTypes.remove(mediaType);
    } else {
      _selectedMediaTypes.add(mediaType);
    }
    filterMedia();
    notifyListeners();
  }

  void filterMedia() {
    if (_selectedMediaTypes.isEmpty) {
      _filteredMediaList = _mediaList;
    } else {
      _filteredMediaList = _mediaList
          .where((media) => _selectedMediaTypes.contains(media.type))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchMedia(String query) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final mediaTypes = _selectedMediaTypes.isEmpty
        ? 'all'
        : _selectedMediaTypes.join(',');

    final url = Uri.parse('https://itunes.apple.com/search?term=$query&media=$mediaTypes');

    try {
      final client = PinningHttpClient(pinnedPublicKey: '');
      final request = http.Request('GET', url);
      final response = await client.send(request);

      if (response.statusCode == 200) {
        final data = json.decode(await response.stream.bytesToString());
        final List<dynamic> results = data['results'];
        _mediaList = results.map((item) => ItunesMedia.fromJson(item)).toList();
        filterMedia();
      } else {
        _errorMessage = 'Failed to fetch data. Please try again.';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class PinningHttpClient extends http.BaseClient {
  final String pinnedPublicKey;
  final HttpClient _httpClient = HttpClient();

  PinningHttpClient({required this.pinnedPublicKey});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {

    _httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      final publicKeyDigest = base64.encode(cert.der);
      return publicKeyDigest == pinnedPublicKey;
    };


    final ioRequest = await _httpClient.openUrl(request.method, request.url);


    request.headers.forEach((key, value) {
      ioRequest.headers.set(key, value);
    });


    if (request is http.Request && request.body.isNotEmpty) {
      ioRequest.add(utf8.encode(request.body));
    } else if (request is http.MultipartRequest) {
      await request.finalize().forEach(ioRequest.add);
    }


    final ioResponse = await ioRequest.close();


    final headers = <String, String>{};
    ioResponse.headers.forEach((key, values) {
      headers[key] = values.join(', ');
    });


    return http.StreamedResponse(
      ioResponse.cast<List<int>>(),
      ioResponse.statusCode,
      headers: headers,
      request: request,
      reasonPhrase: ioResponse.reasonPhrase,
      contentLength: ioResponse.contentLength,
      isRedirect: ioResponse.isRedirect,
      persistentConnection: ioResponse.persistentConnection,
    );
  }

  @override
  void close() {
    _httpClient.close();
  }
}


