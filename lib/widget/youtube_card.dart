import 'package:flutter/material.dart';
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
    return ItemCard(
        width: mediaSize.width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.zero,
        onTap: () => NavigatorHelper().pushNext(YoutubePlayerPage(youtubeId: video.id!)),
        child: Column(
          children: [
            Image.network(
              'https://i.ytimg.com/vi/${video.id}/maxresdefault.jpg',
              fit: BoxFit.cover,
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
                      Text(
                        '${video.channel?.name ?? ''} · ${video.views ?? 0} · ${video.publishedTime ?? ''}',
                        style: AppStyle.textNormal.size12,
                      ),
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
                  Text(
                    channel.name ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
