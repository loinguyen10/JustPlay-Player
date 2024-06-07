import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_justplay_player/model/youtube/video_data.dart';
import 'package:flutter_justplay_player/screen/youtube/player/youtube_player_vm.dart';
import 'package:flutter_chocolatecookies/widget/video_player.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubePlayerPage extends StatefulWidget {
  const YoutubePlayerPage({super.key, required this.youtubeId});
  final String youtubeId;

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  final vm = YoutubePlayerViewModel();
  // late VideoPlayerController vm.videoPlayer;
  late Future<void> _initializeVideoPlayerFuture;

  final sizeWidth = mediaSize.width;
  // final sizeHeight = mediaSize.height;
  String videoLink = '';
  String audioLink = '';
  VideoData? youtubeInfo;

  Future<void> getYTInfo() async {
    VideoData? info = await vm.youtubeDataApi.fetchVideoData(widget.youtubeId);
    youtubeInfo = info;
  }

  Future<void> getYTLink() async {
    try {
      var manifest = await vm.yt.videos.streamsClient.getManifest(widget.youtubeId);
      videoLink = manifest.video.sortByVideoQuality().firstWhere((e) => e.tag <= 299).url.toString();
      audioLink = manifest.audioOnly.last.url.toString();

      vm.videoPlayer = VideoPlayerController.networkUrl(Uri.parse(videoLink))
        ..initialize().then((_) {
          setState(() {});
        });

      _initializeVideoPlayerFuture = vm.videoPlayer.initialize();

      await vm.audioPlayer.setUrl(audioLink);
    } catch (e) {
      print(e);
      getYTLink();
    }
  }

  @override
  void initState() {
    getYTInfo();
    getYTLink();
    super.initState();
    vm.videoPlayer = VideoPlayerController.networkUrl(Uri.parse(videoLink))
      ..initialize().then((_) {
        setState(() {});
      });

    // vm.audioPlayer.play();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    vm.videoPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<YoutubePlayerViewModel>(
        create: (context) => vm,
        child: Consumer<YoutubePlayerViewModel>(
          builder: (context, vm, child) {
            return SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    VideoScreenPlayer(
                      videocontroller: vm.videoPlayer,
                      audioController: vm.audioPlayer,
                    ),
                    space8,
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTitle(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  _buildTitle() {
    final data = youtubeInfo?.video;
    bool open = false;
    return Container(
      width: mediaSize.width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ExpansionTile(
        onExpansionChanged: (value) => open = !open,
        title: Text(data?.title ?? ''),
        subtitle: Row(
          children: [
            Text(data?.shortViewCount ?? ''),
            space8,
            Text(data?.shortDate ?? ''),
          ],
        ),
        children: [
          Text(data?.description ?? ''),
        ],
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
      ),
    );
  }
}
