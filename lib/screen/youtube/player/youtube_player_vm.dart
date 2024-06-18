import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_justplay_player/plugin/youtube/youtube_data_api/youtube_data_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubePlayerViewModel extends ChangeNotifier {
  var yt = YoutubeExplode();
  late VideoPlayerController videoPlayer;
  late PodPlayerController streamPlayer;
  final audioPlayer = AudioPlayer();
  final youtubeDataApi = YoutubeDataApi();
  CommentsList? comments;
  CommentsList? replies;

  Map<String, String> videoJSon = {};

  Future<CommentsList?> getReplies(Comment comment) async {
    CommentsList? replies = await yt.videos.commentsClient.getReplies(comment);
    return replies;
  }
}
