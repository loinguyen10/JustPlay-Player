import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/widget/item_card.dart';
import 'package:flutter_justplay_player/model/spotify/_models.dart';
import 'package:flutter_justplay_player/screen/spotify/search/spotify_vm.dart';
import 'package:flutter_justplay_player/style/color.dart';
import 'package:flutter_justplay_player/widget/spotify_card.dart';

class SpotifyResultPage extends StatefulWidget {
  const SpotifyResultPage({super.key, required this.vm});

  final SpotifyViewModel vm;

  @override
  State<SpotifyResultPage> createState() => _SpotifyResultPageState();
}

class _SpotifyResultPageState extends State<SpotifyResultPage> {
  SpotifyViewModel get _vm => widget.vm;

  bool? _buildListView;
  List related = [];

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
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildTabBar(list: related, title: 'Related search', buildListView: null),
                _vm.trackResult.isNotEmpty ? buildTabBar(list: _vm.trackResult, title: 'Track', buildListView: true) : space0,
                _vm.artistResult.isNotEmpty ? buildTabBar(list: _vm.artistResult, title: 'Artist', buildListView: true) : space0,
                _vm.playlistResult.isNotEmpty ? buildTabBar(list: _vm.playlistResult, title: 'Playlist', buildListView: false) : space0,
                _vm.albumResult.isNotEmpty ? buildTabBar(list: _vm.albumResult, title: 'Album', buildListView: false) : space0,
              ],
            ),
          ),
          Expanded(
            child: _buildListView != null ? (_buildListView! ? buildListView() : buildGridView()) : buildAll(),
          ),
        ],
      ),
    );
  }

  buildListView() {
    return ListView.builder(
      controller: _vm.scrollController,
      itemCount: _vm.result.length,
      itemBuilder: (context, index) {
        final item = _vm.result[index];
        if (item is Artist) {
          return SpArtistCard(artist: item);
        }
        if (item is Track) {
          return SpSongCard(track: item);
        }
        return space0;
      },
    );
  }

  buildGridView() {
    return Center(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        // shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85),
        itemCount: _vm.result.length,
        itemBuilder: (context, index) {
          final item = _vm.result[index];
          if (item is PlaylistSimple) {
            return Center(child: SpPlaylistCard(playlist: item));
          }
          if (item is AlbumSimple) {
            return Center(child: SpAlbumCard(album: item));
          }
          return space0;
        },
      ),
    );
  }

  buildAll() {
    // final listArtist5 = _vm.artistResult.where((artist) => artist.name?.toLowerCase().contains(_vm.searchTextController.text) ?? false).take(1).toList();
    final listPlaylist10 =
        _vm.playlistResult.where((playlist) => playlist.name?.toLowerCase().contains(_vm.searchTextController.text) ?? false).take(10).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          _vm.artistResult.first.name?.toLowerCase().contains(_vm.searchTextController.text) ?? false
              ? Center(child: SpArtistCard(artist: _vm.artistResult.first))
              : space0,
          SizedBox(
            height: listPlaylist10.length > 3 ? 180 : 0,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                for (var playlist in listPlaylist10) Center(child: SpPlaylistCard(playlist: playlist)),
              ],
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _vm.trackResult.take(10).length,
            itemBuilder: (context, index) {
              final item = _vm.trackResult[index];
              return SpSongCard(track: item);
            },
          ),
        ],
      ),
    );
  }

  buildTabBar({required List list, String title = '', bool? buildListView}) {
    return ItemCard(
      onTap: () {
        _vm.result = list;
        _buildListView = buildListView;
        stateChange();
      },
      borderColor: Colors.black,
      cardColor: _vm.result == list ? spPrimaryColor : Colors.transparent,
      child: Text(title),
    );
  }
}
