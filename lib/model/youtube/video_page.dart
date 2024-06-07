import 'dart:convert';
import 'dart:developer';

import 'package:flutter_justplay_player/helper/description_helper.dart';
import 'package:flutter_justplay_player/model/youtube/channel.dart';
import 'package:flutter_justplay_player/model/youtube/thumbnail.dart';

class VideoPage {
  ///Get video id from video page
  String? videoId;

  ///Get video title from video page
  String? title;

  ///Get video date from video page
  String? date;

  ///Get video date from video page
  String? shortDate;

  ///Get video description from video page
  String? description;

  ///Get video channel name from video page
  Channel? channel;

  ///Get video views count as string from video page
  String? viewCount;

  ///Get video views count as string from video page
  String? shortViewCount;

  ///Get video likes count as string from video page
  String? likeCount;

  ///Get video unlikes count as string from video page
  // String? unlikeCount;

  ///Get channel subscribes count as string from video page
  String? subscribeCount;

  VideoPage({
    this.videoId,
    this.title,
    this.channel,
    this.viewCount,
    this.shortViewCount,
    this.subscribeCount,
    this.likeCount,
    this.date,
    this.description,
    this.shortDate,
  });

  factory VideoPage.fromMap(Map<String, dynamic>? map, String videoId) {
    List<Thumbnail> thumbnailChannel = [];

    map?['results']['results']['contents'][1]['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['thumbnail']['thumbnails']
        .forEach((thumbnail) {
      thumbnailChannel.add(Thumbnail(url: thumbnail['url'], width: thumbnail['width'], height: thumbnail['height']));
    });

    final channel = Channel(
      name: map?['results']['results']['contents'][1]['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['title']['runs'][0]['text'],
      thumbnail: thumbnailChannel,
      id: map?['results']['results']['contents'][1]['videoSecondaryInfoRenderer']['owner']['videoOwnerRenderer']['navigationEndpoint']
          ['browseEndpoint']['browseId'],
    );

    return VideoPage(
      videoId: videoId,
      title: map?['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['title']['runs'][0]['text'],
      channel: channel,
      viewCount: map?['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['viewCount']['videoViewCountRenderer']['viewCount']
          ['simpleText'],
      shortViewCount: map?['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['viewCount']['videoViewCountRenderer']['shortViewCount']
          ['simpleText'],
      subscribeCount: map?['results']?['results']?['contents']?[1]?['videoSecondaryInfoRenderer']?['owner']?['videoOwnerRenderer']
          ?['subscriberCountText']?['simpleText'],
      likeCount: map?['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['videoActions']['menuRenderer']['topLevelButtons'][0]
              ['segmentedLikeDislikeButtonViewModel']['likeButtonViewModel']['likeButtonViewModel']['toggleButtonViewModel']['toggleButtonViewModel']
          ['defaultButtonViewModel']['buttonViewModel']['title'],
      // description: collectDescriptionString(map?['results']?['results']?['contents']?[1]?['videoSecondaryInfoRenderer']?['description']?['runs']),
      description: map?['results']?['results']?['contents']?[1]?['videoSecondaryInfoRenderer']?['attributedDescription']?['content'],
      date: map?['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['dateText']['simpleText'],
      shortDate: map?['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['relativeDateText']['accessibility']['simpleText'] ??
          map?['results']['results']['contents'][0]['videoPrimaryInfoRenderer']['relativeDateText']['accessibility']['accessibilityData']['label'],
    );
  }
}
