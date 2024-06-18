import 'package:flutter/material.dart';
import 'package:flutter_justplay_player/api/spotify_api.dart';
import 'package:flutter_justplay_player/plugin/spotify/spotify.dart';

class SpotifyViewModel extends ChangeNotifier {
  // final spotifyAppApi = SpotifyAPI();
  final spotify = SpotifyApi(SpotifyApiCredentials(SpotifyAPI().clientId, SpotifyAPI().clientSecret));

  List result = [];
  final scrollController = ScrollController();
  bool isLoading = false;

  Future<void> search() async {
    try {
      isLoading = true;
      print("Searching:");
      var search = await spotify.search.get('low g').first(2);

      for (var pages in search) {
        if (pages.items == null) {
          print('Empty items');
        } else {
          for (var item in pages.items!) {
            if (item is PlaylistSimple) {
              print('playlist simple: ${item.name}');
            }
            if (item is Artist) {
              print('Artist simple: ${item.name}');
            }
            if (item is Track) {
              print('Track simple: ${item.name}');
            }
            if (item is AlbumSimple) {
              print('AlbumSimple simple: ${item.name}');
            }
            result.add(item);
          }
        }
      }
    } catch (e) {
      print('spotify search: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
