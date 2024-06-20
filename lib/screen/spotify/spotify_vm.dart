import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_justplay_player/api/spotify_api.dart';
import 'package:flutter_justplay_player/plugin/spotify/spotify.dart';

class SpotifyViewModel extends ChangeNotifier {
  // final spotifyAppApi = SpotifyAPI();
  final spotify = SpotifyApi(SpotifyApiCredentials(SpotifyAPI().clientId, SpotifyAPI().clientSecret));

  List<PlaylistSimple> playlistResult = [];
  List<Artist> artistResult = [];
  List<Track> trackResult = [];
  List<AlbumSimple> albumResult = [];
  int resultLength = 0;
  final scrollController = ScrollController();
  bool isLoading = false;
  final focusNode = FocusNode();
  final searchTextController = TextEditingController();
  String lastSearch = '';
  List<String> autoComplete = [];
  List result = [];

  Future<void> search() async {
    try {
      isLoading = true;
      print("Searching:");
      if (searchTextController.text != lastSearch) {
        playlistResult.clear();
        artistResult.clear();
        trackResult.clear();
        albumResult.clear();
        resultLength = 0;
      }
      var search = await spotify.search.get(searchTextController.text).first();

      for (var pages in search) {
        if (pages.items == null) {
          print('Empty items');
        } else {
          for (var item in pages.items!) {
            if (item is PlaylistSimple) {
              playlistResult.add(item);
            }
            if (item is Artist) {
              artistResult.add(item);
            }
            if (item is Track) {
              trackResult.add(item);
            }
            if (item is AlbumSimple) {
              albumResult.add(item);
            }

            resultLength += 1;
          }
        }
      }

      lastSearch = searchTextController.text;
    } catch (e) {
      print('spotify search: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
