import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/widget/item_card.dart';
import 'package:flutter_justplay_player/model/youtube/video_data.dart';
import 'package:flutter_justplay_player/screen/youtube/player/youtube_player_vm.dart';
import 'package:flutter_chocolatecookies/widget/video_player.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter_justplay_player/model/youtube/video.dart' as YTVideoData;

class YoutubePlayerPage extends StatefulWidget {
  const YoutubePlayerPage({super.key, required this.youtubeVideo});
  final YTVideoData.Video youtubeVideo;

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

  String get ytId => widget.youtubeVideo.id!;

  Future<void> getYTInfo() async {
    VideoData? info = await vm.youtubeDataApi.fetchVideoData(ytId);
    youtubeInfo = info;

    var video = await vm.yt.videos.get('https://youtu.be/$ytId');
    vm.comments = await vm.yt.videos.commentsClient.getComments(video);
    stateChange();
  }

  Future<void> getYTLink() async {
    try {
      var manifest = await vm.yt.videos.streamsClient.getManifest(ytId);
      videoLink = manifest.video.sortByVideoQuality().firstWhere((e) => e.tag <= 299).url.toString();
      audioLink = manifest.audioOnly.last.url.toString();

      vm.videoPlayer = VideoPlayerController.networkUrl(
        Uri.parse(videoLink),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      )..initialize().then((_) {
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
    stateChange();
    // if (widget.youtubeVideo.isLive!) {
    vm.streamPlayer = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(
        'https://youtu.be/$ytId',
        live: widget.youtubeVideo.isLive!,
      ),
    )..initialise().then((_) {
        setState(() {});
      });
    // } else {
    //   getYTLink();
    //   vm.videoPlayer = VideoPlayerController.networkUrl(Uri.parse(''))
    //     ..initialize().then((_) {
    //       setState(() {});
    //     });
    // }
    super.initState();

    // vm.audioPlayer.play();
  }

  @override
  void dispose() {
    vm.videoPlayer.dispose();
    vm.streamPlayer.dispose();
    vm.yt.close();
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
                    // widget.youtubeVideo.isLive! ?
                    PodVideoPlayer(controller: vm.streamPlayer)
                    // : VideoScreenPlayer( videocontroller: vm.videoPlayer, audioController: vm.audioPlayer, )
                    ,
                    space8,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTitle(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: vm.comments?.length ?? 0,
                              itemBuilder: (context, index) {
                                CommentsList? replies = getReply(vm.comments![index]) as CommentsList?;
                                return Text('hahaa');
                              },
                            ),
                          ],
                        ),
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
      child: Expanded(
        child: ExpansionTile(
          onExpansionChanged: (value) => open = !open,
          title: Text(data?.title ?? ''),
          subtitle: Row(
            children: [
              Text(data?.shortViewCount ?? ''),
              space8,
              Text(data?.shortDate ?? data?.date ?? ''),
            ],
          ),
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          children: [
            Text(data?.date ?? ''),
            Text(data?.description ?? ''),
            ItemCard(
              borderWidth: 2,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppStyle.textNormal.blackText,
                      children: [
                        const WidgetSpan(
                          child: Icon(Icons.thumb_up, size: 14),
                        ),
                        TextSpan(
                          text: '${data?.likeCount ?? 0}',
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: AppStyle.textNormal.blackText,
                      children: const [
                        WidgetSpan(
                          child: Icon(Icons.thumb_up, size: 14),
                        ),
                        TextSpan(
                          text: '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildComment(Comment comment) {
    return Column(
      children: [
        Text(comment.author),
        Text(comment.text),
        const Row(
          children: [
            Icon(Icons.thumb_up),
            Icon(Icons.thumb_down),
            Icon(Icons.comment),
          ],
        ),
      ],
    );
  }

  Future<CommentsList?> getReply(Comment comment) async {
    final result = await vm.getReplies(comment);
    return result;
  }
}
