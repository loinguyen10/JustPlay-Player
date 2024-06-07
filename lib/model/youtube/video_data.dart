import 'package:flutter_justplay_player/model/youtube/video.dart';
import 'package:flutter_justplay_player/model/youtube/video_page.dart';

class VideoData {
  VideoPage? video;
  List<Video> videosList;

  VideoData({this.video, required this.videosList});
}
