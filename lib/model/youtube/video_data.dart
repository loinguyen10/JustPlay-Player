import 'package:flutter_musicplayer/model/youtube/video.dart';
import 'package:flutter_musicplayer/model/youtube/video_page.dart';

class VideoData {
  VideoPage? video;
  List<Video> videosList;

  VideoData({this.video, required this.videosList});
}
