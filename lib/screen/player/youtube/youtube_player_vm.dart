import 'package:flutter/material.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_musicplayer/plugin/youtube/youtube_data_api/youtube_data_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubePlayerViewModel extends ChangeNotifier {
  var yt = YoutubeExplode();
  late VideoPlayerController videoPlayer;
  final audioPlayer = AudioPlayer();
  final youtubeDataApi = YoutubeDataApi();

  Map<String, String> videoJSon = {};
}
