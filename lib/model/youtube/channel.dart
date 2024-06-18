import 'dart:convert';
import 'dart:developer';

import 'package:flutter_justplay_player/model/youtube/thumbnail.dart';

class Channel {
  ///Youtube channel id
  String? id;

  ///Youtube channel name
  String? name;

  ///Youtube channel user name
  String? userName;

  ///Youtube channel user name
  String? description;

  ///Youtube channel thumbnail
  List<Thumbnail>? thumbnail;

  ///Youtube channel number of videos
  // String? videoCount;

  ///Youtube channel number of sub
  String? subscriberNumber;

  ///Youtube channel verified
  bool? isVerified;

  Channel({
    this.id,
    this.name,
    this.userName,
    this.description,
    this.thumbnail,
    // this.videoCount,
    this.subscriberNumber,
    this.isVerified,
  });

  factory Channel.fromMap(Map<String, dynamic>? map) {
    List<Thumbnail> thumbnails = [];
    map?['channelRenderer']['thumbnail']['thumbnails'].forEach((thumbnail) {
      thumbnails.add(Thumbnail(url: 'https:${thumbnail['url']}', width: thumbnail['width'], height: thumbnail['height']));
    });

    return Channel(
      id: map?['channelRenderer']['channelId'],
      thumbnail: thumbnails,
      userName: map?['channelRenderer']['subscriberCountText']['simpleText'],
      name: map?['channelRenderer']['title']['simpleText'],
      description: map?['channelRenderer']['descriptionSnippet']['runs'][0]['text'],
      // videoCount: map?['channelRenderer']['videoCountText']['runs'] //[0]['text']
      // subscriberNumber: map?['channelRenderer']['videoCountText']['accessibility']['accessibilityData']['label'],
      subscriberNumber: map?['channelRenderer']['videoCountText']['simpleText'],
      isVerified: map?['channelRenderer']['ownerBadges'] != null ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userName": userName,
      "name": name,
      "description": description,
      "thumbnail": thumbnail,
      // "videoCount": videoCount,
      "subscriberNumber": subscriberNumber,
    };
  }
}
