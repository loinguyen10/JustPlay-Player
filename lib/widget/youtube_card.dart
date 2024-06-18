import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chocolatecookies/flutter_chocolatecookies.dart';
import 'package:flutter_chocolatecookies/helper/navigator_helper.dart';
import 'package:flutter_chocolatecookies/widget/item_card.dart';
import 'package:flutter_justplay_player/model/youtube/channel.dart';
import 'package:flutter_justplay_player/model/youtube/playlist.dart';
import 'package:flutter_justplay_player/model/youtube/video.dart';
import 'package:flutter_justplay_player/screen/youtube/player/youtube_player_page.dart';
import 'package:flutter_justplay_player/widget/image_rounded.dart';

class YoutubeVideoCard extends StatelessWidget {
  const YoutubeVideoCard({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final liveButton = Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        color: Colors.red,
        child: Text('LIVE', style: AppStyle.textBold.whiteText),
      ),
    );

    return ItemCard(
        width: mediaSize.width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.zero,
        onTap: () => NavigatorHelper().pushNext(YoutubePlayerPage(youtubeVideo: video)),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  'https://i.ytimg.com/vi/${video.id}/maxresdefault.jpg',
                  fit: BoxFit.cover,
                ),
                video.isLive! ? liveButton : space0,
              ],
            ),
            space8,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                space12,
                ImageRounded(
                  video.channel?.thumbnail?.last.url ?? '',
                  isHttpHeader: true,
                  fit: BoxFit.cover,
                  size: 20,
                ),
                space8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      space4,
                      RichText(
                        text: TextSpan(
                          style: AppStyle.textNormal.size12.blackText,
                          children: [
                            TextSpan(
                              text: '${video.channel?.name ?? ''} ',
                            ),
                            WidgetSpan(
                              child: Icon(Icons.check_circle, size: video.channel!.isVerified! ? 14 : 0),
                            ),
                            TextSpan(
                              text: ' · ${video.views ?? 0}',
                            ),
                            TextSpan(
                              text: ' · ${video.publishedTime ?? ''}',
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // spacer,
                const InkWell(
                  onTap: null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
            space8,
          ],
        ));
  }
}

class YoutubeChannelCard extends StatelessWidget {
  const YoutubeChannelCard({super.key, required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final boxWidth = mediaSize.width / 2.35;
    return ItemCard(
        width: mediaSize.width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: boxWidth,
              alignment: Alignment.center,
              child: ImageRounded(
                channel.thumbnail?.last.url ?? '',
                isHttpHeader: true,
                fit: BoxFit.cover,
                size: 40,
              ),
            ),
            space4,
            Container(
              width: boxWidth,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: AppStyle.textNormal.blackText,
                      children: [
                        TextSpan(
                          text: '${channel.name ?? ''} ',
                        ),
                        WidgetSpan(
                          child: Icon(Icons.check_circle, size: channel.isVerified! ? 14 : 0),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    channel.userName ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    channel.subscriberNumber ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class YoutubePlaylistCard extends StatelessWidget {
  const YoutubePlaylistCard({super.key, required this.playlist});

  final PlayList playlist;

  @override
  Widget build(BuildContext context) {
    return ItemCard(
        width: mediaSize.width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Image.network(
              'https://i.ytimg.com/vi/${playlist.id}/maxresdefault.jpg',
              fit: BoxFit.cover,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            // ImageRounded(
            //   '',
            //   isHttpHeader: true,
            //   fit: BoxFit.cover,
            // ),
            Column(
              children: [
                Text(
                  playlist.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                space4,
                Text('${playlist.channelName ?? ''} · Playlist', style: AppStyle.text(size: 11.5)),
              ],
            ),
            // ],
            // ),
            space8,
          ],
        ));
  }
}
