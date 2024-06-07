import 'dart:developer';

import 'package:flutter_justplay_player/model/youtube/channel.dart';
import 'package:flutter_justplay_player/model/youtube/thumbnail.dart';

class Video {
  ///Youtube video id
  String? id;

  ///Youtube video duration
  String? duration;

  ///Youtube video title
  String? title;

  ///Youtube video channel
  Channel? channel;

  ///Youtube video views
  String? views;

  ///Youtube video thumbnail
  List<Thumbnail>? thumbnails;

  ///Youtube video publish date
  String? publishedTime;

  Video({
    this.id,
    this.duration,
    this.title,
    this.channel,
    this.views,
    this.thumbnails,
    this.publishedTime,
  });

  factory Video.fromMap(Map<String, dynamic>? map) {
    List<Thumbnail> thumbnailsVideo = [];
    List<Thumbnail> thumbnailChannel = [];

    if (map?.containsKey("videoRenderer") ?? false) {
      //Trending and search videos
      var lengthText = map?['videoRenderer']?['lengthText'];

      map?['videoRenderer']['thumbnail']['thumbnails'].forEach((thumbnail) {
        thumbnailsVideo.add(Thumbnail(url: thumbnail['url'], width: thumbnail['width'], height: thumbnail['height']));
      });

      map?['videoRenderer']['channelThumbnailSupportedRenderers']['channelThumbnailWithLinkRenderer']['thumbnail']['thumbnails'].forEach((thumbnail) {
        thumbnailChannel.add(Thumbnail(url: thumbnail['url'], width: thumbnail['width'], height: thumbnail['height']));
      });

      final channel = Channel(
        name: map?['videoRenderer']['longBylineText']['runs'][0]['text'],
        thumbnail: thumbnailChannel,
      );

      return Video(
        id: map?['videoRenderer']?['videoId'],
        duration: (lengthText == null) ? "Live" : lengthText?['simpleText'],
        title: map?['videoRenderer']?['title']?['runs']?[0]?['text'],
        channel: channel,
        thumbnails: thumbnailsVideo,
        publishedTime: map!['videoRenderer']['publishedTimeText']?['simpleText'],
        views: (lengthText == null)
            ? "Views " + map!['videoRenderer']['viewCountText']['simpleText']
            : map?['videoRenderer']?['shortViewCountText']?['simpleText'],
      );
    } else if (map?.containsKey("compactVideoRenderer") ?? false) {
      //Related videos
      map?['compactVideoRenderer']['thumbnail']['thumbnails'].forEach((thumbnail) {
        thumbnailsVideo!.add(Thumbnail(url: thumbnail['url'], width: thumbnail['width'], height: thumbnail['height']));
      });

      map?['compactVideoRenderer']['channelThumbnail']['thumbnails'].forEach((thumbnail) {
        thumbnailChannel.add(Thumbnail(url: thumbnail['url'], width: thumbnail['width'], height: thumbnail['height']));
      });

      final channel = Channel(
        name: map?['compactVideoRenderer']?['ownerText']?[0]['text'],
        thumbnail: thumbnailChannel,
      );

      return Video(
          id: map?['compactVideoRenderer']['videoId'],
          title: map?['compactVideoRenderer']?['title']?['simpleText'],
          duration: map?['compactVideoRenderer']?['lengthText']?['simpleText'],
          thumbnails: thumbnailsVideo,
          channel: channel,
          publishedTime: map?['compactVideoRenderer']?['publishedTimeText']?['simpleText'],
          views: map?['compactVideoRenderer']?['viewCountText']?['simpleText']);
    } else if (map?.containsKey("gridVideoRenderer") ?? false) {
      // String? publishedDateSimpleText = map?['gridVideoRenderer']['shortViewCountText']?['simpleText'];
      String? viewSimpleText = map?['gridVideoRenderer']['shortViewCountText']?['simpleText'];

      map?['gridVideoRenderer']['thumbnail']['thumbnails'].forEach((thumbnail) {
        thumbnailsVideo!.add(Thumbnail(url: thumbnail['url'], width: thumbnail['width'], height: thumbnail['height']));
      });
      return Video(
          id: map?['gridVideoRenderer']['videoId'],
          title: map?['gridVideoRenderer']['title']['runs'][0]['text'],
          duration: map?['gridVideoRenderer']['thumbnailOverlays'][0]['thumbnailOverlayTimeStatusRenderer']['text']['simpleText'],
          thumbnails: thumbnailsVideo,
          // publishedTime: (publishedDateSimpleText != null) ? publishedDateSimpleText : "???",
          views: (viewSimpleText != null) ? viewSimpleText : "???");
    }
    return Video();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "duration": duration,
      "title": title,
      "channel": channel,
      "views": views,
    };
  }
}
