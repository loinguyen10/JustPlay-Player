import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/widget/widget.dart';
import 'package:flutter_justplay_player/model/youtube/channel.dart';
import 'package:flutter_justplay_player/model/youtube/playlist.dart';
import 'package:flutter_justplay_player/model/youtube/video.dart';
import 'package:flutter_chocolatecookies/helper/helper.dart';
import 'package:flutter_justplay_player/screen/youtube/search/youtube_search_vm.dart';
import 'package:flutter_justplay_player/widget/youtube_card.dart';
import 'package:provider/provider.dart';

class YoutubeResultPage extends StatefulWidget {
  const YoutubeResultPage({super.key, required this.vm});

  final YoutubeSearchViewModel vm;

  @override
  State<YoutubeResultPage> createState() => _YoutubeResultPageState();
}

class _YoutubeResultPageState extends State<YoutubeResultPage> {
  YoutubeSearchViewModel get _vm => widget.vm;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _vm,
      builder: (context, child) {
        return LoadingPage(
          isLoading: _vm.isLoading,
          child: ListView.builder(
            itemCount: _vm.result.length,
            itemBuilder: (context, index) {
              if (_vm.result[index] is Video) {
                Video video = _vm.result[index];
                return YoutubeVideoCard(video: video);
              } else if (_vm.result[index] is Channel) {
                Channel channel = _vm.result[index];
                return YoutubeChannelCard(channel: channel);
              } else if (_vm.result[index] is PlayList) {
                PlayList playlist = _vm.result[index];
                return YoutubePlaylistCard(playlist: playlist);
              }
              return Container();
            },
          ),
        );
      },
    );
  }
}
