import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/widget/item_card.dart';
import 'package:flutter_justplay_player/model/spotify/_models.dart';
import 'package:flutter_justplay_player/screen/spotify/spotify_vm.dart';
import 'package:flutter_justplay_player/widget/spotify_card.dart';

class SpotifyResultPage extends StatefulWidget {
  const SpotifyResultPage({super.key, required this.vm});

  final SpotifyViewModel vm;

  @override
  State<SpotifyResultPage> createState() => _SpotifyResultPageState();
}

class _SpotifyResultPageState extends State<SpotifyResultPage> {
  SpotifyViewModel get _vm => widget.vm;

  @override
  void initState() {
    super.initState();
    _vm.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_vm.scrollController.position.atEdge) {
      bool isEnd = _vm.scrollController.offset == _vm.scrollController.position.maxScrollExtent;
      if (isEnd) {
        stateChange();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage(
      isLoading: _vm.isLoading,
      child: ListView.builder(
        controller: _vm.scrollController,
        itemCount: _vm.result.length,
        itemBuilder: (context, index) {
          final item = _vm.result[index];
          if (item is PlaylistSimple) {
            //
          }
          if (item is Artist) {
            return SpArtistCard(artist: item);
          }
          if (item is Track) {
            return SpSongCard(track: item);
          }
          if (item is AlbumSimple) {
            //
          }
          return space0;
        },
      ),
    );
  }
}
